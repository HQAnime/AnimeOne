package org.github.henryquan.animeone.service

import com.github.kittinunf.fuel.Fuel
import it.skrape.core.htmlDocument
import org.github.henryquan.animeone.model.LatestAnime
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class AnimeOneService : BaseService() {

    @Throws(NoSuchElementException::class)
    suspend fun getLatestAnimeList(): List<LatestAnime> {
        return suspendCoroutine { completion ->
            Fuel.get("https://anime1.me/%e7%95%99%e8%a8%80%e6%9d%bf")
                .timeout(10000)
                .responseString { _, _, result ->
                    result.fold(
                        success = { html ->
                            val latestAnimeList: MutableList<LatestAnime> = mutableListOf()
                            htmlDocument(html) {
                                this
                                    .findFirst(".widget-area")
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
                        }, failure = {
                            completion.resume(emptyList())
                        }
                    )
                }
        }
    }
}
