import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/CommonFunctions.dart';
import 'Components/CustomToast/CustomToast.dart';
import 'CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import 'LoginScreen/LoginForm.dart';
import 'PhotoShop/Screen/UploadImage.dart';
import 'PhotoShop/Screen/UploadMultiImage.dart';
import 'Twilio/TwilioScreen.dart';
import 'Twilio/chat_dialog_flow/MainChatScreen.dart';

class AuoLoginScreen extends StatefulWidget {
  const AuoLoginScreen({super.key});

  @override
  State<AuoLoginScreen> createState() => _AuoLoginScreenState();
}
class _AuoLoginScreenState extends State<AuoLoginScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkForAutoLogin();
  }
  Future<void> _checkForAutoLogin() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    final username = localDb.getString("username");
    final uuid = localDb.getString("uuid");
    if (username != null && uuid != null) {
       //Navigator.pushAndRemoveUntil(
      //  context,MaterialPageRoute(builder: (context) => DialogFlowChat(),),(route) => false,);

       Navigator.pushAndRemoveUntil(
         context,MaterialPageRoute(builder: (context) => DashboardScreen(),),(route) => false,);
      showSuccessToast(
          "${capitalizeFirstLetter(username)} is Successfully Login");
    } else {
       //Navigator.pushAndRemoveUntil(
      //  context,MaterialPageRoute(builder: (context) => DialogFlowChat(),),(route) => false,);

       Navigator.pushAndRemoveUntil(
          context,MaterialPageRoute(builder: (context) => MyHomePage(),),(route) => false,);

      // Navigator.pushAndRemoveUntil(
      //     context,MaterialPageRoute(builder: (context) => UploadScreen(),),(route) => false,);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Loading"),),);
  }
}
