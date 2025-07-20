import 'package:flutter/material.dart';

import '../API_Handler/API Funtion.dart';

class Twilioscreen extends StatefulWidget {
  const Twilioscreen({super.key});

  @override
  State<Twilioscreen> createState() => _TwilioscreenState();
}

class _TwilioscreenState extends State<Twilioscreen> {
  final Map<String,dynamic>payload={
    "phone_number":"+919585394516",
    "message":"Hi Sathish Kumar ! Congratulation for the 1 year Anniversary at Datayaan .Hope This year also Going to Excellent Year too "
  };
  @override
  void initState() {
    // TODO: implement initState

    postData(payload);
    super.initState();
  }
  Future<void> postData(Map<String, dynamic>payload) async {
    final dio = ApiClient().client;

    try {
      final response = await dio.post(
        "http://127.0.0.1:8000/make_call/",
        // 'http://192.168.0.134:8000/make_call/',
        data: payload
      );
      // 'http://192.168.1.5:8000/make_call/',

       print('🔽 Final Response Body: ${response.data}');
    } catch (e) {
      print('❗ Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GestureDetector(
        onTap: (){
          postData(payload);
        },
        child: Center(
          child: Text("Data"),
        ),
      ),
    );
  }
}
