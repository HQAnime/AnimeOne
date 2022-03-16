package org.github.henryquan.animeone.data.repository

import android.content.Context
import org.github.henryquan.animeone.data.database.AnimeOneDatabase
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.model.AnimeSchedule

class AnimeOneRepository(context: Context) {
    var animeList: List<AnimeInfo> = emptyList()
        private set

    var animeSchedule: List<AnimeSchedule> = emptyList()
        private set

    private val database = AnimeOneDatabase.getInstance(context)
    private val animeListDAO = database.animeListDAO
    private val animeScheduleDAO = database.animeScheduleDAO

    init {
        animeList = animeListDAO.getAnimeList()
        animeSchedule = animeScheduleDAO.getAnimeSchedule()
    }
}