package org.github.henryquan.animeone.viewmodel.home

import android.content.Context
import android.content.Intent
import androidx.compose.ui.platform.UriHandler
import androidx.lifecycle.ViewModel
import org.github.henryquan.animeone.BuildConfig

class AboutViewModel : ViewModel() {

    lateinit var webLauncher: UriHandler

    fun supportAnimeOne() {
        webLauncher.openUri("https://www.paypal.com/paypalme/yihengquan")
    }

    fun viewOfficialDiscord() {
        webLauncher.openUri("https://discord.com/invite/9JtsaE4")
    }

    /**
     * Show the official AnimeOne website's about page
     */
    fun viewOfficialAbout() {
        webLauncher.openUri("https://anime1.me/%e9%97%9c%e6%96%bc")
    }

    fun viewSourceCode() {
        webLauncher.openUri("https://github.com/HQAnime/AnimeOne")
    }

    fun viewPrivacyPolicy() {
        webLauncher.openUri("https://github.com/HenryQuan/AnimeOne/blob/master/README.md#%E9%9A%B1%E7%A7%81%E6%A2%9D%E6%AC%BE")
    }

    fun viewOpenSource() {

    }

    fun downloadEminaOne() {
        webLauncher.openUri("https://github.com/splitline/emina-one")
    }

    fun downloadAnimeGo() {
        webLauncher.openUri("https://github.com/HQAnime/AnimeGo-Re")
    }

    fun emailDeveloper() {
        webLauncher.openUri("mailto:development.henryquan@gmail.com?subject=[AnimeOne ${BuildConfig.VERSION_NAME}]")
    }

    fun shareAnimeOne(context: Context) {
        val sendIntent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, "https://github.com/HQAnime/AnimeOne")
            type = "text/plain"
        }
        val shareIntent = Intent.createChooser(sendIntent, "分享 AnimeOne")
        context.startActivity(shareIntent)
    }

    fun checkForUpdate() {

    }
}