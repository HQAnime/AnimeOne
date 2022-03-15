package org.github.henryquan.animeone.viewmodel.home

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import org.github.henryquan.animeone.model.LatestAnime
import org.github.henryquan.animeone.data.service.AnimeOneService

/**
 * Latest anime screen view model
 */
class LatestViewModel : ViewModel() {

    var animeList by mutableStateOf<List<LatestAnime>>(emptyList())
        private set

    private val service = AnimeOneService()

    suspend fun loadLatestAnime() {
        // only load if needed to prevent unnecessary requests
        if (animeList.isNotEmpty()) return
        refreshLatestAnime()
    }

    suspend fun refreshLatestAnime() {
        try {
//            animeList = service.getLatestAnimeList()
        } catch (e: Exception) {
            // TODO: show a message to ask the user to send me an email, this can be a centralised solution

        }
    }
}