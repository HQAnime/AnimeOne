package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.viewmodel.home.LatestViewModel

@Composable
fun LatestScreen(
    viewModel: LatestViewModel = viewModel()
) {
    Surface {
        Text("Latest Anime List")
    }
}