package org.github.henryquan.animeone.ui.screen.home

import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.ui.shared.ActionChip
import org.github.henryquan.animeone.ui.theme.AnimeOneTheme
import org.github.henryquan.animeone.ui.theme.Gray200
import org.github.henryquan.animeone.ui.theme.Gray800
import org.github.henryquan.animeone.ui.theme.Gray900
import org.github.henryquan.animeone.viewmodel.home.AnimeListViewModel

@Composable
fun AnimeListScreen(
    viewModel: AnimeListViewModel = viewModel()
) {
    val uiState = viewModel.uiState
    val filterScroll = rememberScrollState()

    LaunchedEffect("load anime list") {
        viewModel.loadAnimeList()
    }

    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Title") })
        },
        floatingActionButton = {
            FloatingActionButton(onClick = { }) {
                Icon(Icons.Default.Search, "動畫列表搜索")
            }
        },
    ) {
        Column {
            Box(Modifier.fillMaxSize()) {
                if (uiState.filteredList.isEmpty()) {
                    CircularProgressIndicator(
                        modifier = Modifier.align(Alignment.Center),
                    )
                } else {
                    Column {
                        Row(Modifier.horizontalScroll(filterScroll)) {
                            uiState.filters.forEach {
                                ActionChip(
                                    text = it,
                                    onClick = { viewModel.filterWith(it) }
                                )
                            }
                        }
                        LazyColumn(
                            modifier = Modifier.fillMaxSize(),
                            contentPadding = PaddingValues(bottom = 64.dp)
                        ) {
                            itemsIndexed(uiState.filteredList) { index, item ->
                                AnimeCell(item, index)
                            }
                            item {
                                Text("沒有更多動畫了")
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun AnimeCell(
    anime: AnimeInfo,
    index: Int,
) {
    // skill if name is not valid
    anime.name?.let { name ->
        val isFirst = if (isSystemInDarkTheme()) Gray900 else Color.White
        val isSecond = if (isSystemInDarkTheme()) Gray800 else Gray200

        Column(
            Modifier
                .fillMaxWidth()
                .background(if (index % 2 == 0) isSecond else isFirst)
                .clickable {

                }
                .padding(8.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(name, textAlign = TextAlign.Center)
            Spacer(Modifier.height(4.dp))
            Row(Modifier.fillMaxWidth()) {
                Text(
                    anime.episode ?: "-",
                    Modifier.weight(1f),
                    textAlign = TextAlign.Center
                )
                Text(
                    anime.yearWithSeason ?: "-",
                    Modifier.weight(1f),
                    textAlign = TextAlign.Center
                )
                Text(
                    anime.subtitle ?: "",
                    Modifier.weight(1f),
                    textAlign = TextAlign.Center
                )
            }
        }
    }
}

@Preview
@Composable
fun AnimeListPreview() {
    AnimeOneTheme {
        Column {
            repeat(10) {
                AnimeCell(
                    anime = AnimeInfo(
                        0,
                        "Name",
                        "1-100",
                        "2022",
                        "??",
                    ), index = it
                )
            }
        }
    }
}

@Preview
@Composable
fun AnimeListPreviewDark() {
    AnimeOneTheme(darkTheme = true) {
        Column {
            repeat(10) {
                AnimeCell(
                    anime = AnimeInfo(
                        0,
                        "Name",
                        "1-100",
                        "2022",
                        "??",
                    ), index = it
                )
            }
        }
    }
}

