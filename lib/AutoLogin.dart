import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/CommonFunctions.dart';
import 'Components/CustomToast/CustomToast.dart';
import 'CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import 'CustomerScreen/CustomerDashboard/CustomerDashboardScreen.dart';
import 'LoginScreen/LoginForm.dart';

class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({super.key});

  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward(); // Start fade animation

    _startSplashProcess();
  }

  Future<void> _startSplashProcess() async {
    await Future.delayed(const Duration(seconds: 3));
    _checkForAutoLogin();
  }

  Future<void> _checkForAutoLogin() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    final username = localDb.getString("username");
    final uuid = localDb.getString("uuid");

    if (username != null && uuid != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TryDashboard()),
            (route) => false,
      );
      showSuccessToast("${capitalizeFirstLetter(username)} logged in");
    } else {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginForm()),
      //       (route) => false,
      // );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TryDashboard()),
            (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            "assets/images/vfx_logo.png",
            width: 220,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
