import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../Firebase/LocalNotification/LocalNotification.dart';
import '../GuruTasks/DistanceCalculator/WalkTrackerScreen.dart';
import '../ShareApp/PdfScreen.dart';
import '../SoundPlay/AudioPlayScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion='';
  String _appName='';
  @override
  void initState() {
    // TODO: implement initState
    _getAppVersion();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                // backgroundImage: NetworkImage(
                //   'https://i.pravatar.cc/150?img=3', // Replace with actual image URL
                // ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Nessa Verve',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'nessaverve@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Section: Account
          const Text(
            'ACCOUNT',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          _buildTile(icon: Icons.person_outline, title: 'Profile Data'),
          _buildTile(icon: Icons.credit_card_outlined, title: 'Billing & Payment'),

          const SizedBox(height: 30),

          // Section: Settings
          const Text(
            'SETTINGS',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          _buildTile(icon: Icons.mail, title: 'Mail Sender',onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>EmailPDFScreen() ,));
          }),
          _buildTile(icon: Icons.directions_walk, title: 'Distance Measurement',onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>WalkTrackerScreen() ,));
          }),
          _buildTile(icon: Icons.notifications_none_outlined, title: 'Notification with Custom Music',onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>LocalnotificationScreen() ,));
          }),
          _buildTile(icon: Icons.audiotrack_sharp, title: 'Audio Player',onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>AudioPickerPlayer() ,));
          }),
          _buildTile(icon: Icons.share, title: 'Share App',onTap: (){
            _shareApp();
          }),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Switch(value: true, onChanged: null),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Icon(Icons.info_outline, color: Colors.blueGrey),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _appName.isNotEmpty ? _appName.toUpperCase() : "App Name",
                    style:  TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _appVersion.isNotEmpty ? _appVersion : "Loading...",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      // _version = 'v${info.version}';
      _appName = packageInfo.appName;
      _appVersion =
      "v${packageInfo.version} (${packageInfo.buildNumber})"; // Example: v1.0.2 (12)
    });
  }

  void _shareApp() {
    Share.share(
        "This Msg from Sathish App");
  }

  Widget _buildTile({required IconData icon, required String title,VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.black87),
          title: Text(
            title,
            style:  TextStyle(fontSize: 14.sp),
          ),
          trailing:  Icon(Icons.arrow_forward_ios, size: 14.sp),
          onTap: onTap,
        ),
         Divider(height: 1.h),

      ],
    );
  }
}
