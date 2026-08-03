package org.github.henryquan.animeone

import android.content.Intent
import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class WebActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_webview)
        // Fall back to the home page when no specific link was remembered,
        // so the bypass never launches with an empty URL.
        val link = intent.getStringExtra("link")?.takeIf { it.isNotBlank() }
            ?: "https://anime1.me/"
        // Clear cookies to get a fresh cf_clearance
        CookieManager.getInstance().removeAllCookies {
            println("Cookies are removed, $it")
        }

        // Load the web view loads anime1.me
        val webView = findViewById<WebView>(R.id.webView)
        webView.settings.javaScriptEnabled = true
        // Cloudflare's challenge (turnstile) needs DOM storage
        webView.settings.domStorageEnabled = true
        webView.clearCache(false)
        // Set up client to get cookie
        webView.webViewClient = WebClient(this)
        webView.loadUrl(link)
    }
}

class WebClient(private val activity: AppCompatActivity) : WebViewClient() {

    // Cloudflare's challenge page fires onPageFinished too, so we cannot
    // finish when the page first loads. Keep polling until the real bypass
    // cookie (cf_clearance) is issued, or until the page stops looking like
    // a challenge. Give up after maxWaitSec.
    private val maxWaitSec = 60
    private var finished = false

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
        waitForCookie(view, 0)
    }

    @Suppress("DEPRECATION")
    override fun onReceivedError(
        view: WebView?, errorCode: Int, description: String?, failingUrl: String?
    ) {
        super.onReceivedError(view, errorCode, description, failingUrl)
        // Keep the activity open so the challenge can run; an error alone
        // must never close the bypass instantly.
        println("webview error: $errorCode $description ($failingUrl)")
    }

    private fun waitForCookie(view: WebView?, attempt: Int) {
        if (view == null || finished) return
        val url = view.url
        // cf_clearance is the definitive "challenge passed" signal.
        val cookie = CookieManager.getInstance().getCookie(url)
        if (cookie?.contains("cf_clearance") == true) {
            finishWithCookie(view, cookie)
            return
        }
        if (attempt >= maxWaitSec) {
            finishWithCookie(view, cookie)
            return
        }
        view.evaluateJavascript(
            """(function() {
                return document.getElementsByTagName('html')[0].innerHTML;
            })()""".trimMargin()
        ) { html ->
            if (finished) return@evaluateJavascript
            // A missing JS result tells us nothing, so keep waiting. The
            // challenge is also still running while its markers are present.
            val stillChecking = html == null ||
                html.contains("Checking your browser before accessing") ||
                html.contains("Just a moment") ||
                html.contains("challenge-platform") ||
                html.contains("cf-chl") ||
                html.contains("cf-browser-verification") ||
                html.contains("Verify you are human") ||
                html.contains("Turnstile")
            if (!stillChecking) {
                finishWithCookie(view, cookie)
            } else {
                view.postDelayed({ waitForCookie(view, attempt + 1) }, 1000)
            }
        }
    }

    private fun finishWithCookie(view: WebView, cookie: String?) {
        if (finished) return
        finished = true
        val userAgent = view.settings.userAgentString
        // free the web view properly here
        view.stopLoading()
        view.onPause()
        view.removeAllViews()

        val main = Intent(this.activity, MainActivity::class.java)
        main.putExtra("cookie", cookie)
        main.putExtra("agent", userAgent)
        this.activity.setResult(1111, main)
        this.activity.finish()
        println("cookie fixed")
    }
}
