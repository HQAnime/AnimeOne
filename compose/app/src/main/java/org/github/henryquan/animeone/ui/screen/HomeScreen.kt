package org.github.henryquan.animeone.ui.screen

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
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
                header = {
                    // TODO: add the logo here or in content??
                    Text("LOGO")
                },
                content = {
                    // This moves all items down
                    Spacer(modifier = Modifier.weight(1f))
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("時間表") }, icon = {
                            Icon(Icons.Default.Search, "時間表")
                        }
                    )
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("動畫列表") }, icon = {
                            Icon(Icons.Default.Search, "動畫列表")
                        }
                    )
                    NavigationRailItem(
                        selected = false,
                        onClick = {},
                        label = { Text("最新") }, icon = {
                            Icon(Icons.Default.Search, "最新")
                        }
                    )
                    // Uncomment this to make it centered
                    // Spacer(modifier = Modifier.weight(1f))
                }
            )
            Column {
                Text("Main Page here")
                Text("Main Page here")
                Text("Main Page here")
                Text("Main Page here")
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