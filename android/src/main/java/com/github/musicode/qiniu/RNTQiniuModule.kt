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
    fun upload(options: ReadableMap, onSuccess: Callback, onFailure: Callback, onProgress: Callback) {

        val path = options.getString("path")
        val key = options.getString("key")
        val zone = options.getString("zone")
        val token = options.getString("token")
        val mimeType = options.getString("mimeType")
        val params = options.getMap("params")

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
                params as? Map<String, String>,
                mimeType,
                false,
                { _, percent ->
                    val map = Arguments.createMap()
                    map.putDouble("progress", percent)
                    onProgress.invoke(map)
                },
                null
        )

        uploadManager.put(path, key, token,
                { _, info, response ->
                    //res包含hash、key等信息，具体字段取决于上传策略的设置
                    if (info.isOK) {
                        val map = Arguments.createMap()
                        map.putBoolean("success", true)
                        onSuccess.invoke(map)
                    }
                    else {
                        // 如果失败，这里可以把 info 信息上报自己的服务器，便于后面分析上传错误原因
                        val map = Arguments.createMap()
                        map.putBoolean("success", false)
                        onFailure.invoke(map)
                    }
                }, uploadOptions)

    }

}