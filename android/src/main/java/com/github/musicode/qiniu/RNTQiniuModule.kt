package com.github.musicode.qiniu

import com.facebook.react.bridge.*
import com.qiniu.android.common.FixedZone
import com.qiniu.android.storage.Configuration
import com.qiniu.android.storage.UploadManager
import com.qiniu.android.storage.UploadOptions

class RNTQiniuModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNTQiniu"
    }

    @ReactMethod
    fun upload(options: ReadableMap, promise: Promise) {

        val path = options.getString("path")
        val key = options.getString("key")
        val zone = options.getString("zone")
        val token = options.getString("token")
        val mimeType = options.getString("mimeType")

        val config = Configuration.Builder()
                .useHttps(true)
                .zone(
                        when (zone) {
                            "huadong" -> FixedZone.zone0
                            "huabei" -> FixedZone.zone1
                            "huanan" -> FixedZone.zone2
                            else -> FixedZone.zoneNa0
                        }
                )
                .build()

        val uploadManager = UploadManager(config)

        val uploadOptions = UploadOptions(
                null,
                mimeType,
                false,
                { _, percent ->
                    // 回调或 promise 只能调用一次，progress 没法用
                },
                null
        )

        uploadManager.put(path, key, token,
                { _, info, response ->
                    // res 包含 hash、key 等信息，具体字段取决于上传策略的设置
                    if (info.isOK) {

                        val map = Arguments.createMap()

                        val iterator = response.keys()
                        while (iterator.hasNext()) {
                            val key = iterator.next()
                            val value = response.get(key)
                            if (value is String) {
                                map.putString(key, value)
                            }
                            else if (value is Int) {
                                map.putInt(key, value)
                            }
                            else if (value is Boolean) {
                                map.putBoolean(key, value)
                            }
                            else if (value is Double) {
                                map.putDouble(key, value)
                            }
                        }

                        promise.resolve(map)
                    }
                    else {
                        // 如果失败，这里可以把 info 信息上报自己的服务器，便于后面分析上传错误原因
                        promise.reject("${info.statusCode}", info.error)
                    }
                }, uploadOptions)

    }

}