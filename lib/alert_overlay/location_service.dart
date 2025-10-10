import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';

import '../PhotoShop/FireStores/FireBaseStores.dart';
import '../PhotoShop/Model/UserListModel.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:location/location.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class LocationService {
  final Location _location = Location();
  IOWebSocketChannel? _channel;
  StreamSubscription<LocationData>? _subscription;
  final FirebaseFirestore db = FirebaseFirestore.instance;



  Timer? _timer;

  Future<void> startWebSocket() async {
    _channel = IOWebSocketChannel.connect(
        "ws://host0.devices.yaantrac.com:8001/websocket");

    // Ensure location service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Ensure location permission is granted
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Send location every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (_) async {
      try {
        final loc = await _location.getLocation();
        final timestamp = DateTime.now().second; // int timestamp

        final data = {
          "latitude": loc.latitude,
          "longitude": loc.longitude,
          "deviceId": "demo77",
          "mobileId": "demo12",
          "tripId": 12,
          "timestamp": timestamp,
        };

        _channel?.sink.add(jsonEncode(data));
        print("Sent to WebSocket: $data");
      } catch (e) {
        print("Error sending location: $e");
      }
    });
  }

// Stop sending
  void stopWebSocket() {
    _timer?.cancel();
    _channel?.sink.close();
    _channel = null;
  }




  // Future<void> startWebSocket() async {
  //
  //   _channel = IOWebSocketChannel.connect("ws://host0.devices.yaantrac.com:8001/websocket");
  //   bool _serviceEnabled = await _location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await _location.requestService();
  //     if (!_serviceEnabled) return;
  //   }
  //
  //   PermissionStatus _permissionGranted = await _location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await _location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) return;
  //   }
  //
  //   _subscription = _location.onLocationChanged.listen((loc)async {
  //     final data = {
  //       "latitude": loc.latitude,
  //       "longitude": loc.longitude,
  //       "deviceId":"demo77",
  //       "mobileId": "demo12",
  //       "tripId":12,
  //        "timestamp": DateTime.now().toIso8601String()
  //     };
  //
  //     _channel?.sink.add(jsonEncode(data));
  //     print("sent to WebSocket");
  //     print(data);
  //
  //     final token = await FirebaseMessaging.instance.getToken();
  //
  //     // final userMap = data.toMap();
  //     // await db.collection('latlong').doc("saaa").set(data);
  //     await FirebaseFireStore().insertUser(
  //         UserListModel(
  //           name: "user!.user!.displayName!",
  //           email: "user.user!.email!",
  //           imageUrl: "user.user!.photoURL!",
  //           createdAt: Timestamp.now(),
  //           role: "user",
  //           firebaseUid:" user.user!.uid!",
  //           status: "online",
  //           lastSeen: Timestamp.now(),
  //           firebaseToken: token.toString(),latLng: {"latlongData":{
  //           "lat": loc.latitude,
  //           "lng": loc.longitude,
  //           // "timestamp": DateTime.now().toIso8601String()
  //
  //         }},
  //         ),
  //         "user.user!.uid");
  //   });
  // }

  // void stopWebSocket() {
  //   _subscription?.cancel();
  //   _channel?.sink.close();
  // }
}
