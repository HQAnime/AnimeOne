package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar
import androidx.compose.runtime.Composable

@Composable
fun AnimeListScreen() {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Title") })
        }
    ) {
        Text("Anime List")
    }
}
