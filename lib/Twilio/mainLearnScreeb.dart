import 'package:delivery_app/PhotoShop/Screen/UploadMultiImage.dart';
import 'package:delivery_app/RBAC/DriverScreen.dart';
import 'package:delivery_app/Twilio/OpenAI.dart';
import 'package:flutter/material.dart';

import '../RBAC/RBACscreen.dart';
import '../RBAC/Screens/RoleBasedDashboard.dart';
import '../SwichAccount/Screens/SwichAccountScreen.dart';
import 'OwnTwilio/OwnTwilioAccount.dart';
import 'chat_dialog_flow/MainChatScreen.dart';

class MainLearnScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'title': 'OPEN AI',
      'subtitle': 'Explore AI capabilities',
      // 'image': 'https://upload.wikimedia.org/wikipedia/commons/0/04/OpenAI_Logo.svg',
    },
    {
      'title': 'FAQ',
      'subtitle': 'Frequently Asked Questions',
      // 'image':
      // 'https://cdn-icons-png.flaticon.com/512/1828/1828843.png',
    },
    {
      'title': 'Supabase Image Upload',
      'subtitle': 'Manage your images',
      // 'image':
      // 'https://upload.wikimedia.org/wikipedia/commons/0/08/Supabase_logo.png',
    },
    {
      'title': 'RBAC',
      'subtitle': 'Manage Access',
      // 'image':
      // 'https://upload.wikimedia.org/wikipedia/commons/0/08/Supabase_logo.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircleAvatar(
                     child: Icon(Icons.scatter_plot_outlined),
                    ),
                  ),
                ),
                title: Text(
                  card['title']!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  card['subtitle']!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if(index==0){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
                  }
                  if(index==1){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => PermissionDemoScreen(),));
                   Navigator.push(context, MaterialPageRoute(builder: (context) => DialogFlowChat(),));
                  }
                  if(index==2){
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => RBACscreen(),));
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => RBACscreen(),));
                  //    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadMultiImage(),));
                     Navigator.push(context, MaterialPageRoute(builder: (context) => SwitchAccountScreen(),));
                  }
                  if(index==3){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyTwilioScreen(),));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => RoleBasedDashboard(),));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => DriverScreen(),));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => UploadMultiImage(),));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
