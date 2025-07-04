// // main.dart
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
//
//
// class FirebaeSignUpScreen extends StatefulWidget {
//   const FirebaeSignUpScreen({super.key});
//
//   @override
//   State<FirebaeSignUpScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<FirebaeSignUpScreen> {
//   final _phoneController = TextEditingController();
//   String? _verificationId;
//
//   Future<void> loginWithPhone(String phoneNumber) async {
//     final fullPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
//     final snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('phone', isEqualTo: fullPhone)
//         .get();
//
//     if (snapshot.docs.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('User not found, please sign up.')),
//       );
//       return;
//     }
//
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: fullPhone,
//       verificationCompleted: (credential) {},
//       verificationFailed: (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Verification failed: ${error.message}')),
//         );
//       },
//       codeSent: (verificationId, _) {
//         _verificationId = verificationId;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => OTPScreen(
//               verificationId: verificationId,
//             ),
//           ),
//         );
//       },
//       codeAutoRetrievalTimeout: (verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 hintText: 'Enter your mobile number',
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 loginWithPhone(_phoneController.text.trim());
//               },
//               child: const Text('Login with OTP'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class OTPScreen extends StatelessWidget {
//   final String verificationId;
//   final TextEditingController _otpController = TextEditingController();
//
//   OTPScreen({super.key, required this.verificationId});
//
//   void verifyOTP(BuildContext context) async {
//     final credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: _otpController.text.trim(),
//     );
//
//     try {
//       await FirebaseAuth.instance.signInWithCredential(credential);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('OTP verification failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Enter OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _otpController,
//               decoration: const InputDecoration(labelText: 'OTP'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => verifyOTP(context),
//               child: const Text('Verify'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: const Center(child: Text('Welcome to Home!')),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../CustomerScreen/CustomerDashboard/CustomerDashboard.dart';

class FirebaeSignUpScreen extends StatefulWidget {
  const FirebaeSignUpScreen({super.key});

  @override
  State<FirebaeSignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<FirebaeSignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _verificationId;

  Future<void> sendOTP(String phoneNumber) async {
    final fullPhone = phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhone,
      verificationCompleted: (credential) {},
      verificationFailed: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${error.message}')),
        );
      },
      codeSent: (verificationId, _) {
        _verificationId = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignupOTPScreen(
              verificationId: verificationId,
              phone: fullPhone,
              name: _nameController.text.trim(),
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendOTP(_phoneController.text.trim());
              },
              child: const Text('Sign Up with OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
class SignupOTPScreen extends StatelessWidget {
  final String verificationId;
  final String phone;
  final String name;
  final TextEditingController _otpController = TextEditingController();

  SignupOTPScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    required this.name,
  });

  void verifyAndCreateUser(BuildContext context) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: _otpController.text.trim(),
    );

    try {
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'phone': phone,
        'created_at': FieldValue.serverTimestamp(),
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) =>  DashboardScreen()),
            (route) => false,
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyAndCreateUser(context),
              child: const Text('Verify & Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}


