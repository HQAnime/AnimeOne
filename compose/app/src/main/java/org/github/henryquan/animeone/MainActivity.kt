package org.github.henryquan.animeone

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.ui.graphics.Color
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import org.github.henryquan.animeone.ui.screen.home.HomeScreen
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme
import org.github.henryquan.animeone.ui.theme.Pink700

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            val systemUiController = rememberSystemUiController()
            if (isSystemInDarkTheme()) {
                systemUiController.setSystemBarsColor(Color.Black)
            } else {
                systemUiController.setNavigationBarColor(Color.White)
                systemUiController.setStatusBarColor(Pink700)
            }

            AnimeOneTheme {
                HomeScreen()
            }
        }
    }
}
