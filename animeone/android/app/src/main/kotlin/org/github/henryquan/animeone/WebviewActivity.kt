package org.github.henryquan.animeone

import android.os.Bundle
import android.os.PersistableBundle
import android.webkit.WebView
import androidx.appcompat.app.AppCompatActivity
import java.net.URI

class WebviewActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        setContentView(R.layout.webview)

        // Load the webview loads anime1.me
        val webview: WebView = findViewById(R.id.webview)
        webview.settings.builtInZoomControls = false
        webview.settings.loadWithOverviewMode = true
        webview.loadUrl("https://anime1.me")
    }
}