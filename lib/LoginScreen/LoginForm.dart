import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/CommonFunctions.dart';
import '../Components/CustomToast/CustomToast.dart';
import '../CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import '../Firebase/LocalNotification/LocalNotification.dart';
import '../GuruTasks/DistanceCalculator/WalkTrackerScreen.dart';
import '../LanguageChanger/Tamil2English.dart';
import '../PhotoShop/FireStores/FireBaseStores.dart';
import '../PhotoShop/FirebaseLogin/FirebaseAuth.dart';
import '../PhotoShop/Model/UserListModel.dart';
import '../Profile/profile_screen.dart';
import '../ShareApp/PdfScreen.dart';
import '../ShareInternet/ShareEmailScreen.dart';
import '../SoundPlay/AudioPlayScreen.dart';
import '../Twilio/TwilioScreen.dart';
import 'RegisterScreen/AddRegister.dart';
import 'RegisterScreen/FireBaseSignup.dart';
import 'RegisterScreen/MobileNumberLogin.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isSigningIn=false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TopCurveClipper(),
              child: Container(
                height: screenSize.height * 0.35,
                width: double.infinity,
                color: const Color(0xFF0C1D37),
                child: const SizedBox(),
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -90),
              child: Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.jpg"),
                    fit: BoxFit.cover, // Fills the container while maintaining aspect ratio
                  ),
                ),
              ),

            ),

            _isSigningIn?Center(child: CircularProgressIndicator(),): Text(
              'VFX Advertisement',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0C1D37),
              ),
            ),
             SizedBox(height: 180.h),
            // Buttons
            buildStartButton(
              title: 'Get Started with Customer',
              buttonColor: Color(0xFF0C1D37),
              onTap: () {
                _isSigningIn?null: loginFunction();
                //Navigator.push(context, MaterialPageRoute(builder: (context) =>SettingsScreen() ,));
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>WalkTrackerScreen() ,));
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardScreen() ,));
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>FirebaeSignUpScreen() ,));
                 //Navigator.push(context, MaterialPageRoute(builder: (context) =>MobileLoginScreen(Role: "Customer",) ,));
                print('Customer tapped');
              },
              containerColor: Colors.white,
            ),
            buildStartButton(
              title: 'Get Started with Delivery Partner',
              buttonColor:Color(0xFF0C1D37),
              onTap: () {
               // Navigator.push(context, MaterialPageRoute(builder: (context) =>LocalnotificationScreen() ,));
                Navigator.push(context, MaterialPageRoute(builder: (context) =>Twilioscreen() ,));
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>ShareEmailScreen() ,));
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>MobileLoginScreen(Role: "Delivery Agent",) ,));

                print('Delivery tapped');
              },
              containerColor: Colors.grey.shade200,
            ),
            TextButton(onPressed: (){
              _shareApp();

            }, child: Text('Share Your Friends')),
            TextButton(onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context) => EmailPDFScreen(),));
            }, child: Text('Generate the PDF'))

          ],
        ),
      ),
    );
  }
  void _shareApp() {
    Share.share(
        "This Msg from Sathish App");
  }

  Widget buildStartButton({
    required String title,
    required Color buttonColor,
    required VoidCallback onTap,
    required Color containerColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        color: containerColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // flat button
              ),
              textStyle: TextStyle(fontSize: 16), // or use .sp if using screen util
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> loginFunction() async {
    final SharedPreferences localDb = await SharedPreferences.getInstance();
    // var connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult.first == ConnectivityResult.none) {
    //   Fluttertoast.showToast(msg: "No internet connection");
    //   return;
    // }
    setState(() {
      _isSigningIn = true;
    });
    try{
      setState(() {
        _isSigningIn = true;
      });
      UserCredential? user = await FirebaseAuthentication().signInWithGoogle();
      print("");
      final token = await FirebaseMessaging.instance.getToken();
      await FirebaseFireStore().insertUser(
          UserListModel(
            name: user!.user!.displayName!,
            email: user.user!.email!,
            imageUrl: user.user!.photoURL!,
            createdAt: Timestamp.now(),
            role: "user",
            firebaseUid: user.user!.uid!,
            status: "online",
            lastSeen: Timestamp.now(),
            firebaseToken: token.toString(),
          ),
          user.user!.uid);
      showSuccessToast(
          "${capitalizeFirstLetter(user.user!.displayName!)} is Successfully Login");
      localDb.setString(
        "username",
        user.user!.displayName!,
      );
      localDb.setString(
        "uuid",
        user.user!.uid,
      );
      if(user!=null){
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen(),),
              (route) => false,
        );
      }else{

print("okkk");
      }


    }catch(e){}
    finally{
      setState(() {
        _isSigningIn = false;
      });
    }

      }

}


class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}