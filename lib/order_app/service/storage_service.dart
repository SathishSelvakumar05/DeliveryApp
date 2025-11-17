import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  static const _storage = FlutterSecureStorage();

  // Save all users as JSON array
  static Future<void> saveUser(String businessId) async {
    final existing = await getUserList();
    if (!existing.contains(businessId)) {
      existing.add(businessId);
      await _storage.write(key: 'users', value: jsonEncode(existing));
    }
  }
  //
  // static Future<List<String>> getUserList() async {
  //   final jsonString = await _storage.read(key: 'users');
  //   if (jsonString == null) return [];
  //   final List<dynamic> data = jsonDecode(jsonString);
  //   return data.map((e) => e.toString()).toList();
  // }
  static Future<List<String>> getUserList() async {
    final jsonString = await _storage.read(key: 'users');
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      // Try decoding as JSON array
      final List<dynamic> data = jsonDecode(jsonString);
      return data.map((e) => e.toString()).toList();
    } catch (_) {
      // Fallback: handle old comma-separated format
      return jsonString.split(',').map((e) => e.trim()).toList();
    }
  }


  static Future<void> clearUsers() async {
    await _storage.delete(key: 'users');
  }
}
