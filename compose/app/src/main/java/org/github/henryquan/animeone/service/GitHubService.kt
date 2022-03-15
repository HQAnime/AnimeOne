package org.github.henryquan.animeone.service

import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import org.github.henryquan.animeone.model.GithubUpdate
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

class GitHubService : BaseService() {
    companion object {
        private var savedGithubUpdate: GithubUpdate? = null
    }

    // This function can only be called once
    suspend fun checkForUpdate(): GithubUpdate? {
        // use the saved one first
        if (savedGithubUpdate != null) return savedGithubUpdate

        return suspendCoroutine { completion ->
            getString("https://raw.githubusercontent.com/HQAnime/AnimeOne/api/app.json") { _, _, result ->
                result.fold(
                    success = {
                        try {
                            val moshi = Moshi.Builder().add(KotlinJsonAdapterFactory()).build()
                            val jsonAdapter = moshi.adapter(GithubUpdate::class.java)
                            val githubUpdate = jsonAdapter.fromJson(it)
                            savedGithubUpdate = githubUpdate
                            completion.resume(githubUpdate)
                        } catch (e: Exception) {
                            completion.resumeWithException(e)
                        }
                    },
                    failure = {
                        completion.resume(null)
                    }
                )
            }
        }
    }
}
