import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:googleapis/airquality/v1.dart';

class UserListModel {
  final String name;
  final String email;
  final Timestamp createdAt;
  final String role;
  final String firebaseUid;
  final String imageUrl;
  final String firebaseToken;
  final Timestamp lastSeen;
  final Timestamp? lastMesssageSentAT;
  final String status;
  final Map<String,dynamic>? latLng;
  final double? radius;

  UserListModel({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.imageUrl,
    required this.role,
    required this.firebaseUid,
    required this.lastSeen,
    required this.status,
    this.lastMesssageSentAT,
    this.radius,
    this.latLng,
    required this.firebaseToken,
  });

  factory UserListModel.fromMap(Map<String, dynamic> map) {
    Timestamp? lastMsgSent;
    if (map['lastMesssageSentAT'] != null) {
      if (map['lastMesssageSentAT'] is Timestamp) {
        lastMsgSent = map['lastMesssageSentAT'];
      } else if (map['lastMesssageSentAT'] is String) {
        final parsed = DateTime.tryParse(map['lastMesssageSentAT']);
        if (parsed != null) {
          lastMsgSent = Timestamp.fromDate(parsed);
        }
      }
    }

    return UserListModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: map['createdAt'] as Timestamp,
      role: map['role'] ?? '',
      firebaseUid: map['firebaseUid'] ?? '',
      status: map['status'] ?? '',
      lastMesssageSentAT: lastMsgSent,
      firebaseToken: map['firebaseToken'] ?? '',
      lastSeen: map['lastSeen'] as Timestamp,
      radius: map['radius'] ?? 0.0,
      latLng: map['latLng'] ?? {},
    );
  }

  // ✅ Correct toMap using Timestamp directly
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'role': role,
      'firebaseUid': firebaseUid,
      'status': status,
      'firebaseToken': firebaseToken,
      'lastSeen': lastSeen,
      'lastMesssageSentAT': lastMesssageSentAT,
      'radius': radius,
      'latLng': latLng,
    };
  }
}
class LatLngState {
  double? latitude;
  double? longitude;

  LatLngState({this.latitude, this.longitude});

  LatLngState.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
