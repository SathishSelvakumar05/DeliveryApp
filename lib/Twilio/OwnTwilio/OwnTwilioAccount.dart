import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'TwilioService.dart';



class MyTwilioScreen extends StatefulWidget {
  @override
  State<MyTwilioScreen> createState() => _MyTwilioScreenState();
}

class _MyTwilioScreenState extends State<MyTwilioScreen> {

  final TwilioService twilioService = TwilioService();

  // late TwilioFlutter twilioFlutter;

  final TextEditingController numberController =
  TextEditingController(text: "+919585394516");
  final TextEditingController messageController =
  TextEditingController(text: "Hello. your order will be delivered within today"); // Default Tamil message

  // Supported languages (Twilio <Say> language codes)
  String selectedLanguage = "ta-IN"; // Default Tamil
  final Map<String, String> languages = {
    // "English (US)": "en-US",
    "Tamil (India)": "ta-IN",
    "Hindi (India)": "hi-IN",
    "English (UK)": "en-GB",
  };

  @override
  void initState() {
    super.initState();

  }



  Future<void> sendSMS() async {
    await twilioService.sendSMS(
      to: numberController.text,
      message: messageController.text,
    );
  }

  Future<void> makeCall() async {
    await twilioService.makeCall(
      to: numberController.text,
      message: messageController.text,
      language: selectedLanguage, // e.g., "en-GB" or "ta-IN"
    );
  }

  Future<void> makeWhatsappCall() async {
    // WhatsApp
    await twilioService.sendWhatsApp(
      to: "+919585394516",
      message: "${messageController.text}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Twilio SMS & Call Test")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Number input
                TextFormField(
                  controller: numberController,
                  decoration: InputDecoration(
                    hintText: "Enter number",
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Phone Number",
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                // Message input
                TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Enter message",
                    prefixIcon: Icon(Icons.message),
                    labelText: "Message",
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                ),
                SizedBox(height: 16),

                // Language dropdown
                DropdownButtonFormField<String>(
                  value: selectedLanguage,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.language),
                    labelText: "Language",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: languages.entries
                      .map((entry) => DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedLanguage = val!;
                    });
                  },
                ),
                SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: sendSMS,
                      icon: Icon(Icons.sms),
                      label: Text("Send SMS"),
                    ),
                    ElevatedButton.icon(
                      onPressed: makeCall,
                      icon: Icon(Icons.call),
                      label: Text("Call"),
                    ),

                  ],
                ),
                ElevatedButton.icon(
                  onPressed: makeWhatsappCall,
                  icon: Icon(Icons.call),
                  label: Text("Whastapp Msg"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



