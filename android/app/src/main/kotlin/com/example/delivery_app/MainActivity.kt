

package com.example.delivery_app

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import android.content.ComponentName
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.delivery_app/service"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startOverlayService" -> {
                    val intent = Intent(this, OverlayService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopOverlayService" -> {
                    val intent = Intent(this, OverlayService::class.java)
                    stopService(intent)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        updateLauncherIcon()
    }

    override fun onResume() {
        super.onResume()
        updateLauncherIcon()
    }

    private fun updateLauncherIcon() {
        val now = Calendar.getInstance()
        val targetDate = Calendar.getInstance().apply { set(2025, Calendar.AUGUST, 26, 9, 42, 0) }
        val endDate = Calendar.getInstance().apply { set(2025, Calendar.AUGUST, 26, 9, 45, 0) }
        val pm = packageManager

        if (now.after(targetDate) && now.before(endDate)) {
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivityNewYear"),
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivity"),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        } else {
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivityNewYear"),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivity"),
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
        }
    }
}


