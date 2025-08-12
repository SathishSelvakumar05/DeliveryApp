import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../PhotoShop/Screen/single_photo_screen.dart';
import '../../main.dart';

class TryDashboard extends StatefulWidget {
  TryDashboard({super.key});

  @override
  State<TryDashboard> createState() => _TryDashboardState();
}

class _TryDashboardState extends State<TryDashboard> {
  String userName = '';
  String photoUrl = '';
  final supabase = Supabase.instance.client;
  List<dynamic> _photos = [];
  bool _loading = true;

  Future<void> _fetchPhotos() async {
    final response = await supabase.from('photos').select();
    print("the response");
    print("${response.runtimeType}");
    print("${response.toString()}");
    setState(() {
      _photos = response;
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = auth.currentUser?.displayName ?? "";
    photoUrl = auth.currentUser?.photoURL ?? "";
    print("skkkkkkkkk");
    print("${userName}");
    print("${photoUrl}");
    _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location & Profile Row
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // background color
                    ),
                    child: ClipOval(
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "${userName}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Iconsax.search_normal),
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upcoming Schedule
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trending Offers",
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold)),
                  Text("See All", style: TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xFF0C1D37),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.user, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Dr. Alana Reuter",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          Text("Dentist Consultation",
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Column(
                      children: const [
                        Text("Monday, 26 July",
                            style: TextStyle(color: Colors.white)),
                        Text("09:00 - 10:00",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Doctor Speciality
              const Text("Doctor Speciality",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    specialityItem(Iconsax.user, "Dentist"),
                    specialityItem(Iconsax.heart, "Cardiologist"),
                    specialityItem(Iconsax.activity, "Orthopedic"),
                    specialityItem(Iconsax.eye, "Neurologist"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nearby Hospitals
              Row(
                children: [
                  Text("Wedding Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              _photos.isEmpty
                  ? SizedBox(
                      height: 100.h,
                      child: Center(child: Text("No Images")),
                    )
                  : SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        itemCount: _photos.length,
                        itemBuilder: (context, index) {
                          final price = _photos[index]['price'] ?? "";
                          final imageUrl = _photos[index]['image1'] ?? "";
                          final desc = _photos[index]['description'] ?? "";
                          return hospitalCard(price: price, imageUrl: imageUrl,description: desc);
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    ),

              const SizedBox(height: 10),


              // Nearby Hospitals
              Row(
                children: [
                  Text("Kids Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              _photos.isEmpty
                  ? SizedBox(
                height: 100.h,
                child: Center(child: Text("No Images")),
              )
                  : SizedBox(
                height: 110.h,
                child: ListView.builder(
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    final price = _photos[index]['price'] ?? "";
                    final imageUrl = _photos[index]['image1'] ?? "";
                    final desc = _photos[index]['description'] ?? "";
                    return hospitalCard(price: price, imageUrl: imageUrl,description: desc);
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget specialityItem(IconData icon, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget hospitalCard({required String price,required String imageUrl,required String description}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: EdgeInsets.only(right: 6),
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12).r,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)).r,
              child: Image.network(
                imageUrl,
                height: 60.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Price row with currency icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 12.sp, color: Colors.green),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Description row with info icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 10.sp, color: Colors.blueGrey),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
