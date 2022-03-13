package org.github.henryquan.animeone.service

import com.github.kittinunf.fuel.Fuel
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine

class AnimeOneService : BaseService() {


    suspend fun getLatestAnimeList(): String? {
        return suspendCoroutine { completion ->
            Fuel.get("https://anime1.me/%e7%95%99%e8%a8%80%e6%9d%bf")
                .timeout(10000)
                .responseString { _, _, result ->
                    result.fold(
                        success = {
                            completion.resume(it)
                        }, failure = {
                            completion.resume(null)
                        }
                    )
                }
        }
    }
}
