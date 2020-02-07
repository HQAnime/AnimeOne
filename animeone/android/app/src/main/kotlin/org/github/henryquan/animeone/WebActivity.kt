package org.github.henryquan.animeone

import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class WebActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.webview)

        // Load the webview loads anime1.me
        val webview = findViewById<WebView>(R.id.webview)
        webview.settings.javaScriptEnabled = true
        // Set up client to get cookie
        val client = WebClient(this)
        webview.webViewClient = client
        // Load anime1.me
        webview.loadUrl("https://anime1.me")
    }
}

class WebClient(val activity: AppCompatActivity) : WebViewClient() {
    override fun onPageFinished(view: WebView?, url: String?) {
        val cookie = CookieManager.getInstance().getCookie(url)
        this.activity.finish()
    }
}
