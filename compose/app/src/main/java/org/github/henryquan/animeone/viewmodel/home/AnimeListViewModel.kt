package org.github.henryquan.animeone.viewmodel.home

import androidx.compose.runtime.*
import androidx.lifecycle.ViewModel
import org.github.henryquan.animeone.data.repository.AnimeOneRepository
import org.github.henryquan.animeone.model.AnimeInfo
import java.time.LocalDateTime
import java.util.*

data class AnimeListUIState(
    private val list: List<AnimeInfo> = emptyList(),
    var filteredList: List<AnimeInfo> = emptyList(),
    val filters: List<String> = emptyList(),
) {
    private val seasons = listOf("冬", "春", "夏", "秋")

    fun loaded(animeList: List<AnimeInfo>): AnimeListUIState {
        return copy(
            list = animeList,
            filteredList = animeList,
            filters = generateFilters(),
        )
    }

    fun filterWith(text: String): AnimeListUIState {
        return apply {
            this.filteredList = this.list.filter {
                it.contains(text)
            }
        }
    }

    /**
     * 4 fixed filters + 4 seasonal filters based on the current date
     */
    private fun generateFilters(): List<String> {
        val filters = mutableListOf("連載中", "劇場版", "OVA", "OAD")

        // add most recent 4 seasons
        var offset = 0
        val calendar = Calendar.getInstance()
        for (i in 0..4) {
            // calendar is going back so no need to increase offset here
            if (i > 0) offset = -3
            calendar.add(Calendar.MONTH, offset)
            val output = getYearAndSeason(calendar)
            // something like 2022冬
            filters.add("${output[0]}${seasons[output[1]]}")
        }
        return filters
    }

    /**
     * A helper function of generateFilters(). Returns [year, season] based on the Calender
     */
    private fun getYearAndSeason(dt: Calendar): List<Int> {
        val year = dt.get(Calendar.YEAR)
        val month = dt.get(Calendar.MONTH)

        val season = when {
            month < 4 -> 0
            month < 7 -> 1
            month < 10 -> 2
            else -> 3
        }

        return listOf(year, season)
    }
}

class AnimeListViewModel : ViewModel() {

    var uiState by mutableStateOf(AnimeListUIState(), neverEqualPolicy())
        private set

    /**
     * Load anime list if not yet loaded
     */
    suspend fun loadAnimeList() {
        // once load the main list once
        if (uiState.filteredList.isNotEmpty()) return

        // reverse the list to show latest first
        val animeList = AnimeOneRepository.getAnimeList().asReversed()
        uiState = uiState.loaded(animeList)
    }

    fun filterWith(text: String) {
        uiState = uiState.filterWith(text)
    }
}