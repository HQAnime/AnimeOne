package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.animation.Crossfade
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CalendarToday
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.NewReleases
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.zIndex
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
    var currentScreen by remember { mutableStateOf(HomeTabs.About.route) }
    val tabs = listOf(HomeTabs.About, HomeTabs.Schedule, HomeTabs.AnimeList, HomeTabs.Latest)

    Scaffold {
        Row {
            NavigationRail(
                modifier = Modifier.width(60.dp),
                content = {
                    // Push all tabs down
                    Spacer(modifier = Modifier.weight(1f))
                    tabs.forEach { tab ->
                        val tabName = tab.route
                        NavigationRailItem(
                            selected = currentScreen == tabName,
                            onClick = { currentScreen = tabName },
                            label = { Text(tab.title) }, icon = {
                                Icon(tab.icon, tab.title)
                            }
                        )
                    }
                    // Uncomment this to make it centered
                    // Spacer(modifier = Modifier.weight(1f))
                }
            )
            Divider(
                modifier = Modifier.width(1.dp)
            )
            Crossfade(targetState = currentScreen, animationSpec = tween(300)) {
                Box(modifier = Modifier.fillMaxSize()) {
                    Box(
                        modifier = Modifier.zIndex(
                            decideZIndex(
                                it,
                                HomeTabs.Latest.route
                            )
                        )
                    ) {
                        LatestScreen()
                    }
                    Box(
                        modifier = Modifier.zIndex(
                            decideZIndex(
                                it,
                                HomeTabs.AnimeList.route
                            )
                        )
                    ) {
                        AnimeListScreen()
                    }
                    Box(
                        modifier = Modifier.zIndex(
                            decideZIndex(
                                it,
                                HomeTabs.Schedule.route
                            )
                        )
                    ) {
                        ScheduleScreen()
                    }
                    Box(
                        modifier = Modifier.zIndex(
                            decideZIndex(
                                it,
                                HomeTabs.About.route
                            )
                        )
                    ) {
                        AboutScreen()
                    }
                }
            }
        }
    }
}

private fun decideZIndex(screen: String, name: String): Float {
    return if (screen == name) 100f else 0f
}

@Preview
@Composable
fun HomeScreenPreview() {
    AnimeOneTheme {
        HomeScreen()
    }
}