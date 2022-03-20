package org.github.henryquan.animeone.data.repository

import android.content.Context
import android.content.SharedPreferences
import org.github.henryquan.animeone.data.database.AnimeListDAO
import org.github.henryquan.animeone.data.database.AnimeListDAO_Impl
import org.github.henryquan.animeone.data.database.AnimeOneDatabase
import org.github.henryquan.animeone.data.database.AnimeScheduleDAO
import org.github.henryquan.animeone.data.service.AnimeOneService
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.model.AnimeSchedule
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

object AnimeOneRepository {

    // DAO
    private lateinit var animeListDAO: AnimeListDAO
    private lateinit var animeScheduleDAO: AnimeScheduleDAO

    // Service
    private val animeOneService = AnimeOneService()

    // Shared preference
    private lateinit var preferences: SharedPreferences

    /**
     * Setup anime one database and DAO
     */
    fun setup(context: Context) {
        val database = AnimeOneDatabase.getInstance(context)
        animeListDAO = database.animeListDAO
        animeScheduleDAO = database.animeScheduleDAO

        preferences = context.getSharedPreferences("AnimeOne", 0)
        // TODO: check if this is a new version??
        // check if data needs to be updated
        // TODO: copy from flutter here
    }

    suspend fun getAnimeList(): List<AnimeInfo> {
        // data is outdated, fetch new data
        if (false) {
            val newAnimeList = animeOneService.getAnimeList()
            return suspendCoroutine { completion ->
                Thread {
                    // drop old table and insert new list
                    animeListDAO.clear()
                    animeListDAO.insertList(newAnimeList)
                    completion.resume(newAnimeList)
                }.start()
            }
        } else {
            return suspendCoroutine { completion ->
                Thread {
                    completion.resume(animeListDAO.getAnimeList())
                }.start()
            }
        }
    }
}
