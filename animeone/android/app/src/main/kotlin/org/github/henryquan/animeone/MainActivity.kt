package org.github.henryquan.animeone

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val animeOneChannel = "org.github.henryquan.animeone"
    private val homePage = "https://anime1.me"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Add method channel to receive calls from Flutter side
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, animeOneChannel).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread
            if (call.method == "getAnimeOneCookie") {
                // Grab the cookie for anime1.me
                val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("http://www.google.com"))
                startActivity(browserIntent)

                //val cookies: String = CookieManager.getInstance().getCookie(homePage)
                result.success("native view")
            } else {
                result.notImplemented()
            }
        }
    }
}
