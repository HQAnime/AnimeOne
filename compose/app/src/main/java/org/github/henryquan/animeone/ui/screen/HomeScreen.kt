package org.github.henryquan.animeone.ui.screen

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
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
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme

@Composable
fun HomeScreen(
) {
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
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("時間表") }, icon = {
                            Icon(Icons.Default.CalendarToday, "時間表")
                        }
                    )
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("動畫列表") }, icon = {
                            Icon(Icons.Default.List, "動畫列表")
                        }
                    )
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("最新") }, icon = {
                            Icon(Icons.Default.NewReleases, "最新")
                        }
                    )
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