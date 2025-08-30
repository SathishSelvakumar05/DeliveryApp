import 'package:flutter/material.dart';
import '../LocalStorage/AppSession.dart';
import '../LocalStorage/SecureStorageManager.dart';


class SwitchAccountScreen extends StatefulWidget {
  const SwitchAccountScreen({super.key});
  @override
  State<SwitchAccountScreen> createState() => _SwitchAccountScreenState();
}
class _SwitchAccountScreenState extends State<SwitchAccountScreen> {
  String? _currentUser;
  String? _token;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }
  Future<void> _loadCurrentUser() async {
    final userId = await AppSession.getCurrentUser();
    if (userId != null) {
      final storage = SecureStorageManager(userId);
      final token = await storage.read(StorageKeys.token);
      setState(() {
        _currentUser = userId;
        _token = token;
      });
    }
  }
  Future<void> _loginAs(String userId) async {
    final storage = SecureStorageManager(userId);
    await storage.save(StorageKeys.token, 'token_for_$userId');
    await storage.save(StorageKeys.credential, 'email_$userId@example.com');
    await storage.save(StorageKeys.isKeepSignIn, 'true');
    await storage.save(StorageKeys.expireTime, DateTime.now().add(const Duration(days: 7)).toIso8601String());
    await AppSession.setCurrentUser(userId);
    await _loadCurrentUser();
  }
  Future<void> _switchUser() async {
    final knownUsers = await AppSession.getKnownUsers();
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView(
        children: knownUsers.map((id) {
          return ListTile(
            title: Text('Switch to $id'),
            onTap: () async {
              Navigator.pop(context);
              await AppSession.setCurrentUser(id);
              await _loadCurrentUser();
            },
          );
        }).toList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Multi-Account Secure Storage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentUser != null) ...[
                Text('Logged in as: $_currentUser'),
                Text('Token: $_token'),
              ] else
                const Text('Not logged in'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _loginAs('user1'),
                child: const Text('Login as user1'),
              ),
              ElevatedButton(
                onPressed: () => _loginAs('user2'),
                child: const Text('Login as user2'),
              ),
              ElevatedButton(
                onPressed: _switchUser,
                child: const Text('Switch Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}