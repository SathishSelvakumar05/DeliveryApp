// app_session.dart

import 'package:shared_preferences/shared_preferences.dart';

class AppSession {

  // static const _currentUserKey = 'current_user';
  //
  // static const _knownUsersKey = 'known_users';

  static Future<void> setCurrentUser(String userId) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("_currentUserKey", userId);

    await _addToKnownUsers(userId);

  }

  static Future<String?> getCurrentUser() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("_currentUserKey");

  }

  static Future<void> logoutCurrentUser() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("_currentUserKey");

  }

  static Future<void> _addToKnownUsers(String userId) async {

    final prefs = await SharedPreferences.getInstance();

    final users = prefs.getStringList("_knownUsersKey") ?? [];

    if (!users.contains(userId)) {

      users.add(userId);

      await prefs.setStringList("_knownUsersKey", users);

    }

  }

  static Future<List<String>> getKnownUsers() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList("_knownUsersKey") ?? [];

  }

}
