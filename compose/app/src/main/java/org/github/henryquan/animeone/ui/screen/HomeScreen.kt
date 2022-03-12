package org.github.henryquan.animeone.ui.screen

import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable

@Composable
fun HomeScreen(
) {
    Scaffold {
        NavigationRail(
            header = {
                NavigationRailItem(selected = false, onClick = {}, label = {
                    Text("Hello")
                }, icon = {
                    Icon(Icons.Default.Search, "Search")
                })
            }
        ) {

        }
    }
}