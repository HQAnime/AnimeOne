package org.github.henryquan.animeone

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val animeOneChannel = "org.github.henryquan.animeone"
    private val webRequestCode = 1111
    private lateinit var methodResult: MethodChannel.Result

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Add method channel to receive calls from Flutter side
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, animeOneChannel).setMethodCallHandler { call, result ->
            this.methodResult = result
            // Note: this method is invoked on the main thread
            if (call.method == "getAnimeOneCookie") {
                // Grab the cookie for anime1.me
                val webIntent = Intent(this.context, WebActivity::class.java)

                // Grab the link, we need to request
                val link = call.argument<String>("link")
                webIntent.putExtra("link", link)

                startActivityForResult(webIntent, webRequestCode)
            } else if (call.method == "restartAnimeOne") {
                this.finish()
                this.startActivity(this.intent)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (this.methodResult != null) {
            if (resultCode == this.webRequestCode) {
                val cookie = data?.getStringExtra("cookie")
                this.methodResult.success(cookie)
            }
        }
    }
}

