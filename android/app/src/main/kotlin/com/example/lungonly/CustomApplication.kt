package com.example.lungonly

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class CustomApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}