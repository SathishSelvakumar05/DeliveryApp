import 'package:delivery_app/pdf_pass_prevent/pdfscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatAI_All/Screen/Appontment_AI.dart';
import 'Components/CommonFunctions.dart';
import 'Components/CustomToast/CustomToast.dart';
import 'CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import 'CustomerScreen/CustomerDashboard/CustomerDashboardScreen.dart';
import 'LoginScreen/LoginForm.dart';
import 'NewWidgets/AutocompleteWidget/AutocompleteWidget.dart';

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
      Navigator.pushAndRemoveUntil(
        context,MaterialPageRoute(builder: (context) => AutoCompleteWidget(),),(route) => false,);

       // Navigator.pushAndRemoveUntil(
       //   context,MaterialPageRoute(builder: (context) => DashboardScreen(),),(route) => false,);
      showSuccessToast(
          "${capitalizeFirstLetter(username)} is Successfully Login");
    } else {
      Navigator.pushAndRemoveUntil(
       context,MaterialPageRoute(builder: (context) => AppointmentChatScreen(),),(route) => false,);

       // Navigator.pushAndRemoveUntil(
       //  context,MaterialPageRoute(builder: (context) => LoginForm(),),(route) => false,);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Loading"),),);
  }
}
