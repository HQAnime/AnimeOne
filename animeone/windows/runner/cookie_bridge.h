#ifndef RUNNER_COOKIE_BRIDGE_H_
#define RUNNER_COOKIE_BRIDGE_H_

#include <flutter/flutter_engine.h>
#include <windows.h>

namespace animeone {

// Custom window message used to hand the collected cookie back from the
// webview thread to the platform thread.
constexpr UINT kCookieResultMessage = WM_APP + 1;

// Bridges the "getAnimeOneCookie" bypass (used on Android via the native
// WebActivity) to Windows by running a WebView2 webview that passes the
// Cloudflare challenge and returns the cf_clearance cookie.
class CookieBridge {
 public:
  // Registers the method channel on the given engine. Must be called from the
  // platform thread.
  static void Register(flutter::FlutterEngine* engine, HWND host_window);

  // Handles kCookieResultMessage, delivering the cookie back to Flutter.
  static void HandleMessage(HWND hwnd, UINT message, WPARAM wparam,
                            LPARAM lparam);
};

}  // namespace animeone

#endif  // RUNNER_COOKIE_BRIDGE_H_
