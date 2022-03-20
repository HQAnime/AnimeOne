package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraph.Companion.findStartDestination
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
    val tabs = listOf(
        HomeTabs.Latest,
        HomeTabs.AnimeList,
        HomeTabs.Schedule,
        HomeTabs.History,
        HomeTabs.About,
    )

    Scaffold(
        bottomBar = {
            BottomNavigation {
                val navBackStackEntry by navController.currentBackStackEntryAsState()
                val currentDestination = navBackStackEntry?.destination
                tabs.forEach { tab ->
                    BottomNavigationItem(
                        icon = { Icon(tab.icon, contentDescription = tab.title) },
                        label = { Text(tab.title) },
                        selected = currentDestination?.hierarchy?.any { it.route == tab.route } == true,
                        onClick = {
                            navController.navigate(tab.route) {
                                // Pop up to the start destination of the graph to
                                // avoid building up a large stack of destinations
                                // on the back stack as users select items
                                popUpTo(navController.graph.findStartDestination().id) {
                                    saveState = true
                                }
                                launchSingleTop = true
                                restoreState = true
                            }
                        }
                    )
                }
            }
        }
    ) {
        NavHost(
            navController = navController,
            startDestination = HomeTabs.Latest.route
        ) {
            composable(HomeTabs.About.route) { AboutScreen(aboutViewModel) }
            composable(HomeTabs.History.route) { WatchHistoryScreen(watchHistoryViewModel) }
            composable(HomeTabs.Schedule.route) { ScheduleScreen(scheduleViewModel) }
            composable(HomeTabs.AnimeList.route) { AnimeListScreen(animeListViewModel) }
            composable(HomeTabs.Latest.route) { LatestScreen(latestViewModel) }
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