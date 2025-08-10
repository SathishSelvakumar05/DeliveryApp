import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../PhotoShop/Screen/single_photo_screen.dart';

class TryDashboard extends StatelessWidget {
  const TryDashboard({super.key});

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
                  Icon(Iconsax.location5, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  const Text(
                    "New York, USA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.user, color: Colors.black54),
                  )
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
                children:  [
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
                  color:Color(0xFF0C1D37),
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
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
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
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SinglePhotoScreen(),));
                  }, child: Text("View more",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15.sp,color: Color(0xFF0C1D37)),))
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    hospitalCard("Excellent",
                        "https://picsum.photos/200/300?1"),
                    hospitalCard("Trending",
                        "https://picsum.photos/200/300?2"),
                  ],
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

  Widget hospitalCard(String name, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(name,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
