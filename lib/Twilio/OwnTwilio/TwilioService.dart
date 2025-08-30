import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TwilioService {
  final String accountSid = dotenv.env["Twilio_SSID"]!;     // Replace
  final String authToken =  dotenv.env["Twilio_Token"]!;       // Replace
  final String twilioNumber =  dotenv.env["Twilio_fromCall_Number"]!; // Replace (must be Twilio number)

  final Dio _dio = Dio();

  /// Send SMS
  Future<void> sendSMS({required String to, required String message}) async {
    try {
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

      final response = await _dio.post(
        "https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json",
        data: {
          "To": to,
          "From": twilioNumber,
          "Body": message,
        },
        options: Options(
          headers: {"Authorization": basicAuth,
            "Content-Type": "application/x-www-form-urlencoded", // 👈 Important
          },
          contentType: Headers.formUrlEncodedContentType, // 👈 Ensures proper encoding

        ),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "SMS sent successfully ✅");
      } else {
        print("${response.data}");
        Fluttertoast.showToast(msg: "Failed to send SMS ❌: ${response.data}");
      }
    } catch (e) {
      print("$e");
      Fluttertoast.showToast(msg: "Error sending SMS ❌: $e");
    }
  }

  /// ✅ Make Voice Call
  Future<void> makeCall({
    required String to,
    required String message,
    required String language,
  }) async {
    try {
      final basicAuth =
          'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

      final response = await _dio.post(
        "https://api.twilio.com/2010-04-01/Accounts/$accountSid/Calls.json",
        data: {
          "To": to,
          "From": twilioNumber,
          "Twiml":
          "<Response><Say voice='alice' language='$language'>$message</Say></Response>",
        },
        options: Options(
          headers: {"Authorization": basicAuth,
            "Content-Type": "application/x-www-form-urlencoded", // 👈 Important
          },
          contentType: Headers.formUrlEncodedContentType, // 👈 Ensures proper encoding


        ),
      );

      if (response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Call initiated successfully ✅");
      } else {
        print("${response.data}");
        Fluttertoast.showToast(msg: "Failed to make call ❌: ${response.data}");
      }
    } catch (e) {
      print("errror $e");
      Fluttertoast.showToast(msg: "Error making call ❌: $e");
    }
  }

  /// ✅ Send WhatsApp Message
    Future<void> sendWhatsApp({required String to, required String message}) async {
      try {
        final basicAuth =
            'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken'));

        final response = await _dio.post(
          "https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json",
          data: {
            "To": "whatsapp:$to",              // 👈 WhatsApp requires this prefix
            "From": "whatsapp:+14155238886", // Your Twilio WhatsApp-enabled number
            "Body": message,
          },
          options: Options(
            headers: {"Authorization": basicAuth,
              "Content-Type": "application/x-www-form-urlencoded", // 👈 Important
            },
            contentType: Headers.formUrlEncodedContentType, // 👈 Ensures proper encoding

          ),
        );

        if (response.statusCode == 201) {
          Fluttertoast.showToast(msg: "WhatsApp message sent ✅");
        } else {
          Fluttertoast.showToast(
              msg: "Failed to send WhatsApp ❌: ${response.data}");
          print("${response.data}");
        }
      } catch (e) {
        print(e);
        Fluttertoast.showToast(msg: "Error sending WhatsApp ❌: $e");
      }
    }
}
