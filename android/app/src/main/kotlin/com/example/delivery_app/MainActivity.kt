package com.example.delivery_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {

    private val CHANNEL = "trip_notifications"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        updateLauncherIcon()
    }

    override fun onResume() {
        super.onResume()
        updateLauncherIcon()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "showTripNotification") {
                    val tripStartMillis = call.argument<Long>("tripStartMillis")
                    if (tripStartMillis != null) {
                        showCountdownNotification(tripStartMillis)
                    }
                    result.success(null)
                }
            }
    }

    private fun updateLauncherIcon() {
        val now = Calendar.getInstance()

        val targetDate = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 26, 9, 42, 0)
        }

        val endDate = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 26, 9, 45, 0)
        }

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
    private fun showCountdownNotification(tripStartMillis: Long) {
        val context = applicationContext
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel("trip_channel", "Trip Notifications", NotificationManager.IMPORTANCE_HIGH)
            manager.createNotificationChannel(channel)
        }

        val notificationLayout = RemoteViews(context.packageName, R.layout.custom_notification)
        val builder = NotificationCompat.Builder(context, "trip_channel")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setCustomContentView(notificationLayout)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        manager.notify(1001, builder.build())

        val handler = android.os.Handler(context.mainLooper)
        val runnable = object : Runnable {
            override fun run() {
                val remainingMillis = tripStartMillis - System.currentTimeMillis()
                if (remainingMillis > 0) {
                    val minutes = (remainingMillis / 1000) / 60
                    val seconds = (remainingMillis / 1000) % 60
                    val timeText = String.format("%02d:%02d", minutes, seconds)
                    notificationLayout.setTextViewText(R.id.notification_timer, timeText)
                    manager.notify(1001, builder.build())
                    handler.postDelayed(this, 1000)
                } else {
                    notificationLayout.setTextViewText(R.id.notification_timer, "Trip started")
                    manager.notify(1001, builder.build())
                }
            }
        }
        handler.post(runnable)
    }


//    private fun showCountdownNotification(tripStartMillis: Long) {
//        val context = applicationContext
//
//        // Create channel if Android O+
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                "trip_channel",
//                "Trip Notifications",
//                NotificationManager.IMPORTANCE_HIGH
//            )
//            val manager = context.getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(channel)
//        }
//
//        // Custom layout with Chronometer
//        val notificationLayout =
//            RemoteViews(context.packageName, R.layout.custom_notification) // 👈 Make sure file exists
//        notificationLayout.setTextViewText(R.id.notification_title, "Trip starts soon")
//
//        val currentTime = System.currentTimeMillis()
//        val remaining = tripStartMillis - currentTime
//        val base = SystemClock.elapsedRealtime() + remaining
//
//        notificationLayout.setChronometer(R.id.notification_timer, base, null, true)
//
//        // Build notification
//        val builder = NotificationCompat.Builder(context, "trip_channel")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setCustomContentView(notificationLayout)
//            .setPriority(NotificationCompat.PRIORITY_HIGH)
//            .setOngoing(true)
//
//        val manager =
//            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        manager.notify(1001, builder.build())
//    }
}
