import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard.dart';

class PassCodeScreen extends StatefulWidget {
  final String userName;
  const PassCodeScreen({super.key, required this.userName});

  @override
  State<PassCodeScreen> createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  final int passLength = 6;
  String enteredPass = "";
  bool isError = false;

  // You can store the real passcode in your API or secure storage.
  // For demo purposes, we hardcode it.
  final String correctPass = "123456";

  void onNumberTap(String number) {
    if (enteredPass.length < passLength) {
      setState(() {
        enteredPass += number;
      });
    }
  }

  void onBackspace() {
    if (enteredPass.isNotEmpty) {
      setState(() {
        enteredPass = enteredPass.substring(0, enteredPass.length - 1);
      });
    }
  }

  void onLogin() {
    if (enteredPass == correctPass) {
      // Navigate to home or next page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful ✅")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MenuScreen(),
        ),
      );

      // TODO: Navigate to your Home screen
    } else {
      setState(() {
        isError = true;
        enteredPass = "";
      });
    }
  }

  Widget buildDot(bool filled) => Container(
    width: 12,
    height: 12,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: filled ? Colors.black : Colors.grey[300],
    ),
  );

  Widget buildNumberButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF3F3F3),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pass Code",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (isError)
            Text("Password is incorrect",
                style: GoogleFonts.poppins(color: Colors.red, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(passLength,
                    (index) => buildDot(index < enteredPass.length)),
          ),
          const SizedBox(height: 40),

          // Number Pad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                for (var row in [
                  ['1', '2', '3'],
                  ['4', '5', '6'],
                  ['7', '8', '9'],
                  ['0']
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var num in row)
                          buildNumberButton(num, onTap: () => onNumberTap(num)),
                        if (row.length == 1)
                          GestureDetector(
                            onTap: onBackspace,
                            child: const Icon(Icons.backspace_outlined, size: 28),
                          )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(160, 50),
            ),
            child: Text("Log In", style: GoogleFonts.poppins(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
