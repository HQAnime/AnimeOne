package org.github.henryquan.animeone.data.service

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import it.skrape.core.htmlDocument
import org.github.henryquan.animeone.model.AnimeInfo
import org.github.henryquan.animeone.model.AnimeSchedule
import org.github.henryquan.animeone.model.LatestAnime
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

data class ServiceResult<T>(
    val success: Boolean,
    val data: T,
    val errorMessage: String? = null,
)

class AnimeOneService : BaseService() {

    /**
     * Get anime schedule based on the season
     * @param season The season string like 2022年冬季新番
     */
    @Throws(NoSuchElementException::class)
    suspend fun getAnimeSchedule(season: String): ServiceResult<List<AnimeSchedule>> {
        return suspendCoroutine { completion ->
            getString("https://anime1.me/$season") { _, _, result ->
                result.fold(
                    success = { html ->
                        val scheduleList: MutableList<AnimeSchedule> = mutableListOf()
                        htmlDocument(html) {
                            this.findFirst("table")
                                .children[1]
                                .children.forEach { tr ->
                                    if (tr.children.size > 1) {
                                        var weekday = 0
                                        tr.children.forEach { td ->
                                            // fix for Sunday because anime1 puts Sunday first
                                            val adjustment = if (weekday == 0) 7 else weekday
                                            scheduleList.add(AnimeSchedule(
                                                name = td.children.first().text,
                                                link = null,
                                                weekday = adjustment
                                            ))
                                            weekday += 1
                                        }
                                    }
                                }
                        }
                    },
                    failure = {
                        completion.resume(
                            ServiceResult(
                                success = false,
                                data = emptyList(),
                                errorMessage = it.localizedMessage,
                            )
                        )
                    }
                )
            }
        }
    }

    @Throws(org.json.JSONException::class, Exception::class)
    suspend fun getAnimeList(): List<AnimeInfo> {
        return suspendCoroutine { completion ->
            getString("https://d1zquzjgwo9yb.cloudfront.net/?_=") { _, _, result ->
                result.fold(
                    success = { html ->
                        val animeList: MutableList<AnimeInfo> = mutableListOf()
                        htmlDocument(html) {
                            val text = this.children.firstOrNull()?.text?.trim()
                            if (text != null) {
                                val moshi: Moshi = Moshi.Builder().build()
                                val listMyData = Types.newParameterizedType(
                                    List::class.java,
                                    List::class.java,
                                    Any::class.java,
                                )
                                // It can be Int or String, ANY is needed here to prevent issues
                                val jsonAdapter: JsonAdapter<List<List<Any>>> =
                                    moshi.adapter(listMyData)

                                val decodedList = jsonAdapter.fromJson(text)

                                decodedList?.forEach { list ->
                                    if (list.size != 6) {
                                        // The format changes, this method should be updated
                                        throw IllegalArgumentException("AnimeOneService - Anime List item must have 6 items")
                                    }

                                    // 0 means that it is 🔞, removed
                                    val animeID = (list[0] as Double).toInt()
                                    if (animeID > 0) {
                                        animeList.add(
                                            AnimeInfo(
                                                link = "https://anime1.me/?cat=${animeID}",
                                                name = list[1] as String,
                                                episode = list[2] as String,
                                                year = list[3] as String,
                                                season = list[4] as String,
                                                subtitle = list[5] as String,
                                            )
                                        )
                                    }
                                }
                            }
                        }

                        completion.resume(animeList)
                    },
                    failure = {
                        completion.resume(emptyList())
                    }
                )
            }
        }
    }

    /**
     * Get the latest anime list from the message board. It is the lightest web page.
     */
    @Throws(NoSuchElementException::class)
    suspend fun getLatestAnimeList(): List<LatestAnime> {
        return suspendCoroutine { completion ->
            getString("https://anime1.me/%e7%95%99%e8%a8%80%e6%9d%bf") { _, _, result ->
                result.fold(
                    success = { html ->
                        val latestAnimeList: MutableList<LatestAnime> = mutableListOf()
                        htmlDocument(html) {
                            this.findFirst(".widget-area")
                                .findFirst("ul")
                                .children.forEach { item ->
                                    if (item.text.trim() != "") {
                                        val anime = item.children.first()
                                        latestAnimeList.add(
                                            LatestAnime(
                                                anime.text,
                                                anime.attribute("href")
                                            )
                                        )
                                    }
                                }
                        }

                        completion.resume(latestAnimeList)
                    },
                    failure = {
                        completion.resume(emptyList())
                    }
                )
            }
        }
    }
}
