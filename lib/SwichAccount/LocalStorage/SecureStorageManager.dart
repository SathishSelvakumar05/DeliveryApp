import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorageManager {
  final String userId;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  SecureStorageManager(this.userId);
  String _userKey(String key) => '${userId}_$key';
  Future<void> save(String key, String value) async {
    await _storage.write(key: _userKey(key), value: value);
  }
  Future<String?> read(String key) async {
    return await _storage.read(key: _userKey(key));
  }
  Future<void> delete(String key) async {
    await _storage.delete(key: _userKey(key));
  }
  Future<void> clearAll() async {
    final all = await _storage.readAll();
    for (final entry in all.entries) {
      if (entry.key.startsWith('${userId}_')) {
        await _storage.delete(key: entry.key);
      }
    }
  }
}

 class StorageKeys {
  static const token = 'token';
  static const credential = 'credential';
  static const isKeepSignIn = 'isKeepSignIn';
  static const expireTime = 'expireTime';
}