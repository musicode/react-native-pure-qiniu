package com.github.musicode.qiniu

import android.os.Build
import com.facebook.react.bridge.*
import android.util.DisplayMetrics
import android.view.Display
import android.content.Context.WINDOW_SERVICE
import android.view.WindowManager
import java.lang.Exception

class RNTQiniuModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "RNTQiniu"
    }

    @ReactMethod
    fun getStatusBarHeight(promise: Promise) {

        val resources = reactApplicationContext.resources
        val resId = resources.getIdentifier("status_bar_height", "dimen", "android")

        val height = if (resId > 0) {
            (resources.getQiniuPixelSize(resId) / resources.displayMetrics.density).toInt()
        }
        else {
            0
        }

        val map = Arguments.createMap()
        map.putInt("height", height)

        promise.resolve(map)

    }

}