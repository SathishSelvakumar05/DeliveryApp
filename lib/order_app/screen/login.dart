import 'package:delivery_app/Components/CustomToast/CustomToast.dart';
import 'package:delivery_app/order_app/screen/select_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/storage_service.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();
  bool rememberMe = false;

  void _onStart() async {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter Business ID")));
      return;
    }

    // Save user only if Remember Me checked
    if (rememberMe) {
      await StorageService.saveUser(id);
    }

    // Navigate to Select User
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectUserScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/image.png',
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            Text("Enter Your Business ID",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Business ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            Row(
              children: [
                Checkbox(value: rememberMe, onChanged: (v) => setState(() => rememberMe = v!)),
                Text('Remember me', style: GoogleFonts.poppins()),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _onStart,
                child: Text("Start", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
