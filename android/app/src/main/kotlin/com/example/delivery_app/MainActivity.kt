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

package com.example.delivery_app
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.view.WindowManager
//import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        // Block screenshots, screen recording, and recent app preview
//        window.setFlags(
//            WindowManager.LayoutParams.FLAG_SECURE,
//            WindowManager.LayoutParams.FLAG_SECURE
//        )
//    }
//
//    override fun onPause() {
//        // Extra protection: Ensure FLAG_SECURE is still applied when app goes to background
//        window.setFlags(
//            WindowManager.LayoutParams.FLAG_SECURE,
//            WindowManager.LayoutParams.FLAG_SECURE
//        )
//        super.onPause()
//    }
//    override fun onCreate(@NonNull savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        Log.d("MainActivity", "onCreate called")
//        updateIcon()
//    }
//
//    private fun updateIcon() {
//        try {
//            IconManager(this).updateAppIcon()
//        } catch (e: Exception) {
//            Log.e("MainActivity", "Error updating icon", e)
//            e.printStackTrace()
//        }
//    }
}

