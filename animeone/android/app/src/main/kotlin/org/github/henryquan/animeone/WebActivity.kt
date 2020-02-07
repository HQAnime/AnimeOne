package org.github.henryquan.animeone

import android.content.Intent
import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity

class WebActivity : AppCompatActivity() {
    private val homePage = "https://anime1.me"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.webview)

        // Load the webview loads anime1.me
        val webview = findViewById<WebView>(R.id.webview)
        webview.settings.javaScriptEnabled = true
        // Set up client to get cookie
        val client = WebClient(this)
        webview.webViewClient = client
        // Load homepage
        webview.loadUrl(homePage)
    }

    override fun onBackPressed() {
        // You cannot go back with back button
        return
    }
}

class WebClient(private val activity: AppCompatActivity) : WebViewClient() {
    override fun onPageFinished(view: WebView?, url: String?) {
        val cookie = CookieManager.getInstance().getCookie(url)
        val main = Intent(this.activity, MainActivity::class.java)
        main.putExtra("cookie", cookie)
        this.activity.setResult(1111, main)
        this.activity.finish()
    }
}
