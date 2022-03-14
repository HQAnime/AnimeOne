package org.github.henryquan.animeone.model

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
data class AnimeInfo(
    val name: String?,
    val link: String?,
    val episode: String?,
    val year: String?,
    val season: String?,
    val subtitle: String?,
)
