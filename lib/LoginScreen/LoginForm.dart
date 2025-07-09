import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../CustomerScreen/CustomerDashboard/CustomerDashboard.dart';
import '../Firebase/LocalNotification/LocalNotification.dart';
import '../GuruTasks/DistanceCalculator/WalkTrackerScreen.dart';
import '../LanguageChanger/Tamil2English.dart';
import '../ShareApp/PdfScreen.dart';
import '../ShareInternet/ShareEmailScreen.dart';
import '../SoundPlay/AudioPlayScreen.dart';
import 'RegisterScreen/AddRegister.dart';
import 'RegisterScreen/FireBaseSignup.dart';
import 'RegisterScreen/MobileNumberLogin.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

            const Text(
              'Delivery App',
              style: TextStyle(
                fontSize: 32,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) =>WalkTrackerScreen() ,));
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>ShareEmailScreen() ,));
                Navigator.push(context, MaterialPageRoute(builder: (context) =>MobileLoginScreen(Role: "Delivery Agent",) ,));

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