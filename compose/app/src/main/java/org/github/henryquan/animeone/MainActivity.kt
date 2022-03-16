package org.github.henryquan.animeone

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.ui.graphics.Color
import androidx.lifecycle.ViewModelProvider
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import kotlinx.coroutines.coroutineScope
import org.github.henryquan.animeone.data.repository.AnimeOneRepository
import org.github.henryquan.animeone.ui.screen.home.HomeScreen
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme
import org.github.henryquan.animeone.ui.theme.Pink700
import org.github.henryquan.animeone.viewmodel.home.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // setup all view models here
        val aboutViewModel = ViewModelProvider(this).get(AboutViewModel::class.java)
        val watchHistoryViewModel = ViewModelProvider(this).get(WatchHistoryViewModel::class.java)
        val scheduleViewModel = ViewModelProvider(this).get(ScheduleViewModel::class.java)
        val animeListViewModel = ViewModelProvider(this).get(AnimeListViewModel::class.java)
        val latestViewModel = ViewModelProvider(this).get(LatestViewModel::class.java)

        // setup repositories
        Thread {
            val animeOneRepository = AnimeOneRepository(applicationContext)
        }.start()

        setContent {
            val systemUiController = rememberSystemUiController()
            if (isSystemInDarkTheme()) {
                systemUiController.setSystemBarsColor(Color.Black)
            } else {
                systemUiController.setStatusBarColor(Pink700)
                systemUiController.setNavigationBarColor(Color.White)
            }

            AnimeOneTheme {
                HomeScreen(
                    aboutViewModel,
                    watchHistoryViewModel,
                    scheduleViewModel,
                    animeListViewModel,
                    latestViewModel
                )
            }
        }
    }
}
