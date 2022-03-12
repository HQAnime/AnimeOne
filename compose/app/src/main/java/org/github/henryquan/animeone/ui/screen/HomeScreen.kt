package org.github.henryquan.animeone.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.NewReleases
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
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
}

@Composable
fun HomeScreen(
) {
    val navController = rememberNavController()
    val tabs = listOf(HomeTabs.Schedule, HomeTabs.AnimeList, HomeTabs.Latest)

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("AnimeOne Compose") }
            )
        }
    ) {
        Row {
            NavigationRail(
                content = {
                    // TODO: update the logo here
                    Text("LOGO")
                    // TODO: ideally, there should be a line extending the icon
                    // This moves all items down
                    Spacer(
                        modifier = Modifier
                            .weight(1f)
                            .width(4.dp)
                            .clip(CircleShape)
                            .background(Color.Black)
                    )
                    tabs.forEach { tab ->
                        val state by navController.currentBackStackEntryAsState()
                        val currentRoute = state?.destination?.route
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

            NavHost(navController = navController, startDestination = "latest") {
                composable(HomeTabs.Latest.route) { Text("Latest") }
                composable(HomeTabs.AnimeList.route) { Text("Anime List") }
                composable(HomeTabs.Schedule.route) { Text("Schedule") }
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