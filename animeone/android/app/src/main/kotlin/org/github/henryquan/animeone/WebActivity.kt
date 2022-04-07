package org.github.henryquan.animeone

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class WebActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_webview)
        val link = intent.getStringExtra("link")!!
        // Clear cookies to get
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            CookieManager.getInstance().removeAllCookies {
                println("Cookies are removed, $it")
            }
        }

        // Load the web view loads anime1.me
        val webView = findViewById<WebView>(R.id.webView)
        webView.settings.javaScriptEnabled = true
        webView.clearCache(false)
        // Set up client to get cookie
        val client = WebClient(this)
        webView.webViewClient = client
        // Load whichever page that needs cookie
        webView.loadUrl(link)
    }
}

class WebClient(private val activity: AppCompatActivity) : WebViewClient() {

    override fun onPageFinished(view: WebView?, url: String?) {
        super.onPageFinished(view, url)
        view?.evaluateJavascript(
            """(function() {
                return "<html>" + document.getElementsByTagName('html')[0].innerHTML + "</html>";
            })()""".trimMargin()
        ) {
            // Make sure the checking view has passed
            if (!it.contains("Checking your browser before accessing")) {
                val userAgent = view.settings.userAgentString
                val cookie = CookieManager.getInstance().getCookie(url)

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
    }
}
