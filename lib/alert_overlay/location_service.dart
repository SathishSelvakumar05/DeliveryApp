import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:location/location.dart';
import 'package:web_socket_channel/io.dart';

import '../PhotoShop/FireStores/FireBaseStores.dart';
import '../PhotoShop/Model/UserListModel.dart';

class LocationService {
  final Location _location = Location();
  IOWebSocketChannel? _channel;
  StreamSubscription<LocationData>? _subscription;
  final FirebaseFirestore db = FirebaseFirestore.instance;



  Future<void> startWebSocket() async {

    _channel = IOWebSocketChannel.connect("wss://your-websocket-endpoint");
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

    _subscription = _location.onLocationChanged.listen((loc)async {
      final data = {
        "lat": loc.latitude,
        "lng": loc.longitude,
        "timestamp": DateTime.now().toIso8601String()
      };
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
          "user.user!.uid");
      _channel?.sink.add(jsonEncode(data));
    });
  }

  void stopWebSocket() {
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
