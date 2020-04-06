package org.github.henryquan.animeone

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.webkit.CookieManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity

lateinit var link: String

class WebActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.webview)
        link = intent.getStringExtra("link")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            CookieManager.getInstance().removeAllCookies {
                println("Cookies are removed? $it")
            }
        }

        // Load the webview loads anime1.me
        val webview = findViewById<WebView>(R.id.webview)
        webview.settings.javaScriptEnabled = true
        webview.clearCache(false)
        // Set up client to get cookie
        val client = WebClient(this)
        webview.webViewClient = client
        // Load whichever page that needs cookie
        webview.loadUrl(link)
    }

    override fun onBackPressed() {
        // You cannot go back with back button
        return
    }
}

class WebClient(private val activity: AppCompatActivity) : WebViewClient() {
    override fun onPageFinished(view: WebView?, url: String?) {
        println(url)
        if (link == url) return
        val cookie = CookieManager.getInstance().getCookie(url)
        val main = Intent(this.activity, MainActivity::class.java)
        main.putExtra("cookie", cookie)
        this.activity.setResult(1111, main)
        this.activity.finish()
    }
}
