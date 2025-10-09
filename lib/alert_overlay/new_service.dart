import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_background_service/android.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';

import '../PhotoShop/FireStores/FireBaseStores.dart';
import '../PhotoShop/Model/UserListModel.dart';

final Location _location = Location();
IOWebSocketChannel? _channel;
StreamSubscription<LocationData>? _subscription;

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized(); // add this at the top
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService(
    // your app icon in mipmap
    );
  }

  try {
    _channel = IOWebSocketChannel.connect("wss://your-real-server.com/path");
  } catch (e) {
    print("❌ WebSocket connect failed: $e");
    return;
  }

  bool serviceEnabled = await _location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await _location.requestService();
    if (!serviceEnabled) return;
  }

  PermissionStatus permissionGranted = await _location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await _location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;
  }

  _subscription = _location.onLocationChanged.listen((loc)async {
    final data = {
      "lat": loc.latitude,
      "lng": loc.longitude,
      "timestamp": DateTime.now().toIso8601String(),
    };
    print("📡 Sending location: $data");
    final token = await FirebaseMessaging.instance.getToken();

    // final userMap = data.toMap();
    // await db.collection('latlong').doc("saaa").set(data);
    await FirebaseFireStore().insertUser(
        UserListModel(
          name: "user!.user!.displayName!",
          email: "user.user!.email!",
          imageUrl: "user.user!.photoURL!",
          createdAt: Timestamp.now(),
          role: "user",
          firebaseUid:" user.user!.uid!",
          status: "online",
          lastSeen: Timestamp.now(),
          firebaseToken: token.toString(),latLng: {"latlongData":{
          "lat": loc.latitude,
          "lng": loc.longitude,
          "timestamp": DateTime.now().toIso8601String()
        }},
        ),
        "user.use.uid");
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }

    // _channel?.sink.add(jsonEncode(data));
  });

  service.on("stopService").listen((event) async {
    await _subscription?.cancel();
    _channel?.sink.close();
    service.stopSelf();
    print("🛑 Background service stopped");
  });
}
@pragma('vm:entry-point')
Future<void> onStartNew(ServiceInstance service) async {
  // Required for Android 8.0+
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService(

    );
  }

  final Location _location = Location();
  IOWebSocketChannel _channel =
  IOWebSocketChannel.connect("wss://your-websocket-endpoint");

  bool _serviceEnabled = await _location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await _location.requestService();
    if (!_serviceEnabled) return;
  }

  PermissionStatus _permissionGranted = await _location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await _location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) return;
  }

  StreamSubscription? _subscription;
  _subscription = _location.onLocationChanged.listen((loc) async {
    final data = {
      "lat": loc.latitude,
      "lng": loc.longitude,
      "timestamp": DateTime.now().toIso8601String()
    };
    _channel.sink.add(jsonEncode(data));
    print("📡 Sent location: $data");
  });

  service.on("stopService").listen((event) async {
    await _subscription?.cancel();
    _channel.sink.close();
    service.stopSelf();
    print("🛑 Service stopped because overlay closed");
  });
}

