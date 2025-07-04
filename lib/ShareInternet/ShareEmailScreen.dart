import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ShareEmailScreen extends StatelessWidget {
  final String subject = 'Hello from Flutter';
  final String body = 'This is a message shared via Flutter app.';
  final String email = 'sathishselvakumae55@gmail.com';

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print('Could not launch email app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Email Share')),
        body: Center(
          child: ElevatedButton(
            onPressed: _sendEmail,
            child: Text('Share via Email'),
          ),
        ),
      ),
    );
  }
}
