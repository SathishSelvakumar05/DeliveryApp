import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  String _appVersion='';
  String _appName='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAppVersion();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: const Text('Profile'),
        backgroundColor:Color(0xfff5f5f5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Color(0xfff5f5f5),
          elevation: 0,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [

                Expanded(child: Center(child: Text('Profile Process is Going on'),)),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              // padding: const EdgeInsets.all(16),
              // decoration: BoxDecoration(
              //   color: Colors.grey.shade100,
              //   borderRadius: BorderRadius.circular(12),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.black.withOpacity(0.05),
              //       blurRadius: 6,
              //       offset: const Offset(0, 2),
              //     ),
              //   ],
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // const Icon(Icons.info_outline, color: Colors.blueGrey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _appName.isNotEmpty ? _appName.toUpperCase() : "App Name",
                            style: const TextStyle(
                              fontSize: 16,
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
                  // const Icon(Icons.verified, color: Colors.green)
                ],
              ),
            ),
          ),
                    SizedBox(height: 20,)
              ],
            )
          ),
        ),
      ),
    );
  }

  //get app version
  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      // _version = 'v${info.version}';
      _appName = packageInfo.appName;
      _appVersion =
      "v${packageInfo.version} (${packageInfo.buildNumber})"; // Example: v1.0.2 (12)
    });
  }


  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}



