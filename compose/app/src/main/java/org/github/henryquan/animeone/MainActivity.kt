package org.github.henryquan.animeone

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material.Text
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import org.github.henryquan.animeone.ui.screen.HomeScreen
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            AnimeOneTheme {
                HomeScreen()
            }
        }
    }
}
