
//import android.content.ComponentName
//import android.content.pm.PackageManager
//import android.os.Bundle
//import io.flutter.embedding.android.FlutterActivity
//import java.util.Calendar

package com.example.delivery_app

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tracking_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startService" -> {
                        val intent = Intent(this, TrackingService::class.java)
                        startForegroundService(intent)
                        result.success(true)
                    }
                    "stopService" -> {
                        val intent = Intent(this, TrackingService::class.java)
                        stopService(intent)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}

//class MainActivity: FlutterActivity() {
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        updateLauncherIcon()
//    }
//
//    override fun onResume() {
//        super.onResume()
//        updateLauncherIcon()
//    }
//
//    private fun updateLauncherIcon() {
//        val now = Calendar.getInstance()
//
//        // Target date: August 25, 2025
//        val targetDate = Calendar.getInstance().apply {
//            set(2025, Calendar.AUGUST, 26, 9, 42, 0)
//        }
//
//        val endDate = Calendar.getInstance().apply {
//            set(2025, Calendar.AUGUST, 26, 9, 45, 0)
//        }
//
//        val pm = packageManager
//
//        if (now.after(targetDate) && now.before(endDate)) {
//            // Enable special alias
//            pm.setComponentEnabledSetting(
//                ComponentName(this, "com.example.delivery_app.MainActivityNewYear"),
//                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
//                PackageManager.DONT_KILL_APP
//            )
//            // Disable default alias
//            pm.setComponentEnabledSetting(
//                ComponentName(this, "com.example.delivery_app.MainActivity"),
//                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
//                PackageManager.DONT_KILL_APP
//            )
//        } else {
//            // Revert to default alias
//            pm.setComponentEnabledSetting(
//                ComponentName(this, "com.example.delivery_app.MainActivityNewYear"),
//                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
//                PackageManager.DONT_KILL_APP
//            )
//            pm.setComponentEnabledSetting(
//                ComponentName(this, "com.example.delivery_app.MainActivity"),
//                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
//                PackageManager.DONT_KILL_APP
//            )
//        }
//    }
//}



