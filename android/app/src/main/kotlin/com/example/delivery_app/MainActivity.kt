package com.example.delivery_app

import android.content.ComponentName
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.util.Calendar

class MainActivity: FlutterActivity() {

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

        // Target date: August 25, 2025
        val targetDate = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 26, 9, 42, 0)
        }

        val endDate = Calendar.getInstance().apply {
            set(2025, Calendar.AUGUST, 26, 9, 45, 0)
        }

        val pm = packageManager

        if (now.after(targetDate) && now.before(endDate)) {
            // Enable special alias
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivityNewYear"),
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP
            )
            // Disable default alias
            pm.setComponentEnabledSetting(
                ComponentName(this, "com.example.delivery_app.MainActivity"),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        } else {
            // Revert to default alias
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



//package com.example.delivery_app
//
//import io.flutter.embedding.android.FlutterActivity
//
//
////class MainActivity: FlutterActivity()
//
////package com.example.change_icon
//
//
//import io.flutter.embedding.android.FlutterActivity
//import android.os.Bundle
//import androidx.annotation.NonNull
//import android.util.Log
//import com.example.change_icon.IconManager
//
//
//class MainActivity: FlutterActivity() {
//    override fun onCreate(@NonNull savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        Log.d("MainActivity", "onCreate called")
//        updateIcon()
//    }
//
//
//    private fun updateIcon() {
//        try {
//            IconManager(this).updateAppIcon()
//        } catch (e: Exception) {
//            Log.e("MainActivity", "Error updating icon", e)
//            e.printStackTrace()
//        }
//    }
//}

//package com.example.delivery_app
//import io.flutter.embedding.android.FlutterActivity
//import android.os.Bundle
//import android.view.WindowManager
////import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity() {
//
//}

