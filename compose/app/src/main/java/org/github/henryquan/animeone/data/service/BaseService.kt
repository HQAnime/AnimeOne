package org.github.henryquan.animeone.data.service

import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.core.ResponseResultHandler

open class BaseService {

    fun getString(path: String, handler: ResponseResultHandler<String>) {
        Fuel.get(path).timeout(10000).responseString(handler)
    }
}
