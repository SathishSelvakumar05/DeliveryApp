import 'package:delivery_app/order_app/screen/pass_code.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/storage_service.dart';
import 'login.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  List<String> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final list = await StorageService.getUserList();
    setState(() => users = list);
  }

  void _clearUsers() async {
    await StorageService.clearUsers();
    setState(() => users = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black, onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
        }),
        title: Text("Select User",
            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black54),
            onPressed: _clearUsers,
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: users.isEmpty
            ? Center(
          child: Text(
            "No saved users yet.",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
          ),
        )
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: users.length,
          itemBuilder: (context, index) {
            return GestureDetector(onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PassCodeScreen(userName: users[index]),
                ),
              );
            },child:
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(users[index],overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 6),
                    Text("Restaurant Owner",
                        style: GoogleFonts.poppins(
                            fontSize: 12 , color: Colors.grey[600])),
                  ],
                ),
              ),
            ));

          },
        ),
      ),
    );
  }
}
