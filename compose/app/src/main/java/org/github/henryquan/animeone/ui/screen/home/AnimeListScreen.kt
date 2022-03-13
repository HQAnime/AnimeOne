package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar
import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.viewmodel.home.AnimeListViewModel

@Composable
fun AnimeListScreen(
    viewModel: AnimeListViewModel = viewModel()
) {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Title") })
        }
    ) {
        Text("Anime List")
    }
}
