package org.github.henryquan.animeone.viewmodel.home

import androidx.lifecycle.ViewModel
import org.github.henryquan.animeone.data.repository.AnimeOneRepository
import org.github.henryquan.animeone.model.AnimeInfo

class AnimeListViewModel : ViewModel() {

    var list: List<AnimeInfo> = emptyList()
        private set

    /**
     * Load anime list if not yet loaded
     */
    suspend fun loadAnimeList() {
        if (list.isNotEmpty()) return
        this.list = AnimeOneRepository.getAnimeList()
    }
}