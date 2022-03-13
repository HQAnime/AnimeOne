package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.animation.Crossfade
import androidx.compose.animation.core.TweenSpec
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.ListItem
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.viewmodel.home.LatestViewModel

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun LatestScreen(
    viewModel: LatestViewModel = viewModel()
) {
    LaunchedEffect("get latest anime") {
        viewModel.loadLatestAnime()
    }

    val scrollState = rememberScrollState()
    val animeList = viewModel.animeList

    Box {
        Crossfade(
            targetState = animeList.isEmpty(),
            animationSpec = TweenSpec(300),
        ) { loading ->
            if (loading) {
                Box(Modifier.fillMaxSize()) {
                    CircularProgressIndicator(Modifier.align(Alignment.Center))
                }
            } else {
                Column(modifier = Modifier.verticalScroll(scrollState)) {
                    animeList.forEach { anime ->
                        anime.name?.let {
                            ListItem(
                                text = { Text(it) },
                                modifier = Modifier.clickable {

                                }
                            )
                        }
                    }
                }
            }
        }
    }
}
