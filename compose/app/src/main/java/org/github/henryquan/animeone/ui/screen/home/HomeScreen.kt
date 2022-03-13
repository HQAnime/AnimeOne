package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme
import org.github.henryquan.animeone.viewmodel.home.*

sealed class HomeTabs(val route: String, val title: String, val icon: ImageVector) {
    object Latest : HomeTabs("latest", "最新", Icons.Default.NewReleases)
    object AnimeList : HomeTabs("anime_list", "動畫列表", Icons.Default.List)
    object Schedule : HomeTabs("schedule", "時間表", Icons.Default.CalendarToday)
    object History : HomeTabs("history", "歷史記錄", Icons.Default.History)
    object About : HomeTabs("about", "關於", Icons.Default.Info)
}

@Composable
fun HomeScreen(
    aboutViewModel: AboutViewModel = viewModel(),
    watchHistoryViewModel: WatchHistoryViewModel = viewModel(),
    scheduleViewModel: ScheduleViewModel = viewModel(),
    animeListViewModel: AnimeListViewModel = viewModel(),
    latestViewModel: LatestViewModel = viewModel(),
) {
    val navController = rememberNavController()
    val navigationState = navController.currentBackStackEntryAsState()
    val currentScreen = navigationState.value?.destination?.route
    val tabs = listOf(
        HomeTabs.About,
        HomeTabs.History,
        HomeTabs.Schedule,
        HomeTabs.AnimeList,
        HomeTabs.Latest
    )

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("AnimeOne") })
        }
    ) {
        Row {
            NavHost(
                modifier = Modifier.weight(1f),
                navController = navController,
                startDestination = HomeTabs.Latest.route
            ) {
                composable(HomeTabs.About.route) { AboutScreen(aboutViewModel) }
                composable(HomeTabs.History.route) { WatchHistoryScreen(watchHistoryViewModel) }
                composable(HomeTabs.Schedule.route) { ScheduleScreen(scheduleViewModel) }
                composable(HomeTabs.AnimeList.route) { AnimeListScreen(animeListViewModel) }
                composable(HomeTabs.Latest.route) { LatestScreen(latestViewModel) }
            }
            NavigationRail(
                modifier = Modifier.width(60.dp),
                content = {
                    // Push all tabs down
                    Spacer(modifier = Modifier.weight(1f))
                    tabs.forEach { tab ->
                        val tabName = tab.route
                        NavigationRailItem(
                            selected = currentScreen == tabName,
                            onClick = {
                                if (currentScreen != tabName)
                                    navController.navigate(tabName)
                            },
                            label = { Text(tab.title) }, icon = {
                                Icon(tab.icon, tab.title)
                            }
                        )
                    }
                    // Uncomment this to make it centered
                    // Spacer(modifier = Modifier.weight(1f))
                }
            )
        }
    }
}

@Preview
@Composable
fun HomeScreenPreview() {
    AnimeOneTheme {
        HomeScreen()
    }
}