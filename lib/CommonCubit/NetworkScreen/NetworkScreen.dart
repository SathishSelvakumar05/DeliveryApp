// network_error_screen.dart
import 'package:flutter/material.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          '🚫 No Internet Connection',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }
}
