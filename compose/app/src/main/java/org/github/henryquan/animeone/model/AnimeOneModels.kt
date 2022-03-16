package org.github.henryquan.animeone.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import org.github.henryquan.animeone.utility.AnimeOne

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
    val year: String?,
    val season: String?,
    val subtitle: String?,
) {
    val link: String = AnimeOne.url + "/?cat=$animeID"
}

/**
 * Anime Schedule with the day in a week
 */
@Entity(tableName = "anime_schedule_table")
data class AnimeSchedule(
    @PrimaryKey()
    val name: String?,
    val link: String?,
    val weekday: Int?,
)