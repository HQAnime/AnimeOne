package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.NewReleases
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme

sealed class HomeTabs(val route: String, val title: String, val icon: ImageVector) {
    object Latest : HomeTabs("latest", "最新", Icons.Default.NewReleases)
    object AnimeList : HomeTabs("anime_list", "動畫列表", Icons.Default.List)
    object Schedule : HomeTabs("schedule", "時間表", Icons.Default.CalendarToday)
    object About : HomeTabs("about", "關於", Icons.Default.Info)
}

@Composable
fun HomeScreen(
) {
    val navController = rememberNavController()
    val state by navController.currentBackStackEntryAsState()
    val currentRoute = state?.destination?.route

    val tabs = listOf(HomeTabs.About, HomeTabs.Schedule, HomeTabs.AnimeList, HomeTabs.Latest)

    Scaffold() {
        Row {
            NavigationRail(
                modifier = Modifier.width(60.dp),
                content = {
                    // Push all tabs down
                    Spacer(modifier = Modifier.weight(1f))
                    tabs.forEach { tab ->
                        val tabRoute = tab.route
                        NavigationRailItem(
                            selected = currentRoute == tabRoute,
                            onClick = { navController.navigate(tabRoute) },
                            label = { Text(tab.title) }, icon = {
                                Icon(tab.icon, tab.title)
                            }
                        )
                    }
                    // Uncomment this to make it centered
                    // Spacer(modifier = Modifier.weight(1f))
                }
            )

            NavHost(navController = navController, startDestination = HomeTabs.About.route) {
                composable(HomeTabs.Latest.route) { LatestScreen() }
                composable(HomeTabs.AnimeList.route) { AnimeListScreen() }
                composable(HomeTabs.Schedule.route) { ScheduleScreen() }
                composable(HomeTabs.About.route) { AboutScreen() }
            }
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