package org.github.henryquan.animeone.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import org.github.henryquan.animeone.utility.AnimeOne

interface Filterable {
    fun contains(text: String): Boolean
}

/**
 * Latest anime with only the name and its link
 */
data class LatestAnime(
    val name: String?,
    val link: String?,
)

/**
 * The complete anime information used by the anime list
 */
@Entity(tableName = "anime_list_table")
data class AnimeInfo(
    @PrimaryKey()
    val animeID: Int,
    val name: String?,
    val episode: String?,
    val yearWithSeason: String?,
    val subtitle: String?,
): Filterable {
    fun getLink(): String = AnimeOne.url + "/?cat=$animeID"
    override fun contains(text: String): Boolean {
        if (name?.contains(text) == true) return true
        if (episode?.contains(text) == true) return true
        if (yearWithSeason?.contains(text) == true) return true
        if (subtitle?.contains(text) == true) return true
        return false
    }
}

/**
 * Anime Schedule with the day in a week
 */
@Entity(tableName = "anime_schedule_table")
data class AnimeSchedule(
    @PrimaryKey(autoGenerate = true)
    val id: Int = 0,
    val name: String?,
    val link: String?,
    val weekday: Int?,
)