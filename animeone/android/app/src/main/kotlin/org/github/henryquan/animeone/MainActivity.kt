package org.github.henryquan.animeone

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val animeOneChannel = "org.github.henryquan.animeone"
    private val webRequestCode = 1111
    private var methodResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Add method channel to receive calls from Flutter side
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            animeOneChannel
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread
            when (call.method) {
                "getAnimeOneCookie" -> {
                    methodResult = result
                    val link = call.argument<String>("link")!!
                    bypassBrowserCheck(link)
                }
                "restartAnimeOne" -> restart()
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (resultCode == webRequestCode) {
            val cookie = data?.getStringExtra("cookie")
            val agent = data?.getStringExtra("agent")
            methodResult?.success(listOf(cookie, agent))
        }
    }

    private fun bypassBrowserCheck(link: String) {
        // Grab the cookie for anime1.me
        val webIntent = Intent(context, WebActivity::class.java)
        webIntent.putExtra("link", link)
        startActivityForResult(webIntent, webRequestCode)
    }

    private fun restart() {
        this.finish()
        this.startActivity(intent)
    }
}

