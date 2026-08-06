#include "cookie_bridge.h"

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <WebView2.h>
#include <windows.h>

#include <fstream>
#include <memory>
#include <string>
#include <thread>
#include <utility>

#include "webview/webview.h"

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;
using flutter::MethodCall;
using flutter::MethodChannel;
using flutter::MethodResult;
using flutter::StandardMethodCodec;

constexpr char kChannelName[] = "org.github.henryquan.animeone";

// Handed from the platform thread to the webview thread; ownership moves back
// to the platform thread via a custom window message when done.
struct WebviewContext {
  std::unique_ptr<MethodResult<EncodableValue>> result;
  std::string link;
  std::string blob;  // URL-encoded "cookie|userAgent"
  HWND host = nullptr;
  webview_t w = nullptr;
  int attempts = 0;
  const int max_attempts = 60;  // ~60 seconds at one poll per second
};

// Diagnostic log next to the executable so it is easy to find.
void Log(const std::string& msg) {
  wchar_t path[MAX_PATH] = {};
  GetModuleFileNameW(nullptr, path, MAX_PATH);
  std::wstring log_path(path);
  auto slash = log_path.find_last_of(L'\\');
  if (slash != std::wstring::npos) {
    log_path = log_path.substr(0, slash + 1);
  }
  log_path += L"animeone_cookie_debug.log";
  std::ofstream log(log_path, std::ios::app);
  log << msg << "\n";
}

std::wstring ToWide(const std::string& s) {
  if (s.empty()) return {};
  int len = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, nullptr, 0);
  std::wstring out(len, L'\0');
  MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, out.data(), len);
  out.pop_back();  // drop the terminating NUL
  return out;
}

std::string ToNarrow(const wchar_t* s) {
  if (s == nullptr || *s == L'\0') return {};
  int len = WideCharToMultiByte(CP_UTF8, 0, s, -1, nullptr, 0, nullptr, nullptr);
  std::string out(len, '\0');
  WideCharToMultiByte(CP_UTF8, 0, s, -1, out.data(), len, nullptr, nullptr);
  out.pop_back();  // drop the terminating NUL
  return out;
}

// Percent-encodes so the blob survives the channel untouched (Dart decodes it).
std::string UrlEncode(const std::string& s) {
  static const char* hex = "0123456789ABCDEF";
  std::string out;
  out.reserve(s.size() * 2);
  for (unsigned char c : s) {
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
        (c >= '0' && c <= '9') || c == '-' || c == '_' || c == '.' || c == '~') {
      out += static_cast<char>(c);
    } else {
      out += '%';
      out += hex[c >> 4];
      out += hex[c & 0xF];
    }
  }
  return out;
}

void DeliverResult(WebviewContext* ctx);

// Poll step scheduled on the webview thread: asks the cookie manager for the
// site's cookies and checks for cf_clearance.
void PollCookieStep(webview_t w, void* arg);

// Completes asynchronously on the webview thread when cookies are fetched.
struct CookieListHandler : public ICoreWebView2GetCookiesCompletedHandler {
  explicit CookieListHandler(WebviewContext* c) : ctx(c) {}
  WebviewContext* ctx;
  ULONG refs = 1;

  HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, void** ppv) override {
    if (riid == __uuidof(ICoreWebView2GetCookiesCompletedHandler) ||
        riid == IID_IUnknown) {
      *ppv = this;
      AddRef();
      return S_OK;
    }
    *ppv = nullptr;
    return E_NOINTERFACE;
  }
  ULONG STDMETHODCALLTYPE AddRef() override { return ++refs; }
  ULONG STDMETHODCALLTYPE Release() override {
    if (--refs == 0) {
      delete this;
      return 0;
    }
    return refs;
  }

  HRESULT STDMETHODCALLTYPE
  Invoke(HRESULT result, ICoreWebView2CookieList* list) override {
    std::string cookie;
    if (SUCCEEDED(result) && list != nullptr) {
      unsigned int count = 0;
      list->get_Count(&count);
      for (unsigned int i = 0; i < count; ++i) {
        ICoreWebView2Cookie* c = nullptr;
        if (SUCCEEDED(list->GetValueAtIndex(i, &c)) && c != nullptr) {
          LPWSTR name = nullptr;
          LPWSTR value = nullptr;
          if (SUCCEEDED(c->get_Name(&name)) &&
              SUCCEEDED(c->get_Value(&value))) {
            std::string n = ToNarrow(name);
            if (!n.empty()) {
              cookie += n;
              cookie += '=';
              cookie += ToNarrow(value);
              cookie += "; ";
            }
          }
          if (name != nullptr) CoTaskMemFree(name);
          if (value != nullptr) CoTaskMemFree(value);
          c->Release();
        }
      }
    }

    if (cookie.find("cf_clearance") != std::string::npos ||
        ctx->attempts >= ctx->max_attempts) {
      Log("poll finished, cookie=" + cookie);
      // Grab the browser user agent so Dart requests look consistent.
      std::string ua;
      auto* controller = static_cast<ICoreWebView2Controller*>(
          webview_get_native_handle(ctx->w,
                                    WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER));
      if (controller != nullptr) {
        ICoreWebView2* webview = nullptr;
        if (SUCCEEDED(controller->get_CoreWebView2(&webview)) &&
            webview != nullptr) {
          ICoreWebView2Settings* settings = nullptr;
          if (SUCCEEDED(webview->get_Settings(&settings)) &&
              settings != nullptr) {
            // get_UserAgent lives on ICoreWebView2Settings2.
            ICoreWebView2Settings2* settings2 = nullptr;
            if (SUCCEEDED(settings->QueryInterface(
                    __uuidof(ICoreWebView2Settings2),
                    reinterpret_cast<void**>(&settings2))) &&
                settings2 != nullptr) {
              LPWSTR agent = nullptr;
              if (SUCCEEDED(settings2->get_UserAgent(&agent)) &&
                  agent != nullptr) {
                ua = ToNarrow(agent);
                CoTaskMemFree(agent);
              }
              settings2->Release();
            }
            settings->Release();
          }
          webview->Release();
        }
      }
      ctx->blob = UrlEncode(cookie) + "|" + UrlEncode(ua);
      DeliverResult(ctx);
    } else {
      ctx->attempts++;
      Log("poll " + std::to_string(ctx->attempts) + ": no cf_clearance yet");
      webview_dispatch(ctx->w, PollCookieStep, ctx);
    }
    return S_OK;
  }
};

void PollCookieStep(webview_t w, void* arg) {
  auto* ctx = static_cast<WebviewContext*>(arg);
  auto* controller = static_cast<ICoreWebView2Controller*>(
      webview_get_native_handle(w, WEBVIEW_NATIVE_HANDLE_KIND_BROWSER_CONTROLLER));
  if (controller == nullptr) {
    // WebView2 not ready yet; try again shortly.
    webview_dispatch(w, PollCookieStep, ctx);
    return;
  }
  ICoreWebView2* webview = nullptr;
  if (FAILED(controller->get_CoreWebView2(&webview)) || webview == nullptr) {
    webview_dispatch(w, PollCookieStep, ctx);
    return;
  }
  // get_CookieManager lives on ICoreWebView2_2.
  ICoreWebView2_2* webview2 = nullptr;
  if (FAILED(webview->QueryInterface(__uuidof(ICoreWebView2_2),
                                     reinterpret_cast<void**>(&webview2))) ||
      webview2 == nullptr) {
    webview->Release();
    webview_dispatch(w, PollCookieStep, ctx);
    return;
  }
  webview->Release();
  ICoreWebView2CookieManager* manager = nullptr;
  if (FAILED(webview2->get_CookieManager(&manager)) || manager == nullptr) {
    webview2->Release();
    webview_dispatch(w, PollCookieStep, ctx);
    return;
  }
  webview2->Release();
  auto url = ToWide(ctx->link);
  // refs starts at 1 (ours); WebView2 AddRefs on receipt, and the final
  // Release after Invoke destroys the handler.
  auto* handler = new CookieListHandler(ctx);
  if (FAILED(manager->GetCookies(url.c_str(), handler))) {
    handler->Release();
    manager->Release();
    webview_dispatch(w, PollCookieStep, ctx);
    return;
  }
  handler->Release();  // hand off our reference
  manager->Release();
}

void DeliverResult(WebviewContext* ctx) {
  if (ctx->w != nullptr) {
    webview_terminate(ctx->w);
  }
}

// Runs the webview on its own thread (webview_run blocks with its own loop).
void RunWebview(WebviewContext* ctx) {
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
  ctx->w = webview_create(0, nullptr);
  Log(ctx->w != nullptr ? "webview created" : "webview create FAILED");
  if (ctx->w != nullptr) {
    webview_set_title(ctx->w, "AnimeOne - Cloudflare verification");
    webview_set_size(ctx->w, 480, 640, WEBVIEW_HINT_NONE);
    webview_navigate(ctx->w, ctx->link.c_str());
    // Start the cookie polling once the webview event loop is running.
    webview_dispatch(ctx->w, PollCookieStep, ctx);
    webview_run(ctx->w);
    Log("webview run returned");
    webview_destroy(ctx->w);
    Log("webview destroyed");
  }
  ::CoUninitialize();

  // Hand the collected blob back to the platform thread.
  ::PostMessage(ctx->host, animeone::kCookieResultMessage,
                reinterpret_cast<WPARAM>(ctx), 0);
}

}  // namespace

namespace animeone {

void CookieBridge::Register(flutter::FlutterEngine* engine, HWND host_window) {
  auto channel = std::make_unique<MethodChannel<EncodableValue>>(
      engine->messenger(), kChannelName, &StandardMethodCodec::GetInstance());
  channel->SetMethodCallHandler(
      [host_window](const MethodCall<EncodableValue>& call,
                    std::unique_ptr<MethodResult<EncodableValue>> result) {
        if (call.method_name() == "restartAnimeOne") {
          // Restarting the app is an Android concept; on desktop the saved
          // cookie is picked up immediately, so this is a no-op.
          result->Success();
          return;
        }
        if (call.method_name() != "getAnimeOneCookie") {
          result->NotImplemented();
          return;
        }

        auto* ctx = new WebviewContext();
        ctx->result = std::move(result);
        ctx->host = host_window;
        const auto* args = std::get_if<EncodableMap>(call.arguments());
        if (args != nullptr) {
          auto link = args->find(EncodableValue("link"));
          if (link != args->end()) {
            const auto* value = std::get_if<std::string>(&link->second);
            if (value != nullptr) {
              ctx->link = *value;
            }
          }
        }
        if (ctx->link.empty()) {
          ctx->link = "https://anime1.me/";
        }
        Log("getAnimeOneCookie link=" + ctx->link);

        std::thread(RunWebview, ctx).detach();
      });

  // Keep the channel alive for the lifetime of the app.
  static std::unique_ptr<MethodChannel<EncodableValue>> channel_storage =
      std::move(channel);
}

void CookieBridge::HandleMessage(HWND hwnd, UINT message, WPARAM wparam,
                                 LPARAM lparam) {
  if (message != kCookieResultMessage) {
    return;
  }
  auto* ctx = reinterpret_cast<WebviewContext*>(wparam);
  if (ctx == nullptr) {
    return;
  }
  // The blob is URL-encoded ("cookie|userAgent"); Dart decodes and splits it.
  ctx->result->Success(EncodableList{EncodableValue(ctx->blob)});
  delete ctx;
}

}  // namespace animeone
