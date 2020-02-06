package org.github.henryquan.animeone

import android.os.Bundle
import android.os.PersistableBundle
import android.webkit.WebView
import androidx.appcompat.app.AppCompatActivity

class WebviewActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.webview)

        // Load the webview loads anime1.me
        val webview = findViewById<WebView>(R.id.webview)
        webview.loadUrl("https://anime1.me")
    }
}