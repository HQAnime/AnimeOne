package org.github.henryquan.animeone.model

import androidx.room.Entity
import androidx.room.PrimaryKey

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
    val name: String?,
    val link: String?,
    val episode: String?,
    val year: String?,
    val season: String?,
    val subtitle: String?,
)

/**
 * Anime Schedule with the day in a week
 */
data class AnimeSchedule(
    val name: String?,
    val link: String?,
    val weekday: Int?,
)