import 'package:android_intent_plus/flag.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

// Future<void> startForegroundServiceStart() async {
//   final service = FlutterBackgroundService();
//
//   // initialize if not already
//   await service.startService();
//
//   print("✅ Foreground service started");
// }
import 'package:flutter/services.dart';

import 'package:android_intent_plus/android_intent.dart';

import 'package:android_intent_plus/android_intent.dart';

Future<void> startOverlayServiceAndroid() async {
  try {
    final intent = AndroidIntent(
      action: 'com.example.delivery_app.OverlayService',
      package: 'com.example.delivery_app',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
    print("try succes");
  } catch (e) {
    print("Error starting service:");
    print(e.toString());
  }
}



void startOverlayService() {

}




class NativeLocationService {
  static const MethodChannel _channel =
  MethodChannel('com.example.delivery_app/location_service');

  static Future<void> startTracking() async {
    await _channel.invokeMethod('startTracking');
  }

  static Future<void> stopTracking() async {
    await _channel.invokeMethod('stopTracking');
  }
}


class OverlayServiceHelper {
  static const _channel = MethodChannel('com.example.delivery_app/service');

  static Future<void> startOverlayService() async {
    try {
      await _channel.invokeMethod('startOverlayService');
      print("OverlayService started");
    } catch (e) {
      print("Error starting service: $e");
    }
  }
  static Future<void> stopOverlayService() async {
    try {
      await _channel.invokeMethod('stopOverlayService');
      print("OverlayService stopped");
    } catch (e) {
      print("Error stopping service: $e");
    }
  }
}


