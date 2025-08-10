import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import '../PhotoShop/Widgets/ProductCard.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class ClinicDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> photo;

  const ClinicDetailsScreen({super.key,required this.photo});

  @override
  State<ClinicDetailsScreen> createState() => _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends State<ClinicDetailsScreen> {
  int _currentImageIndex=1;
  List<String>overAllData=[];
  @override
  void initState() {
    // TODO: implement initState
    convertData();
    super.initState();
  }
  convertData() {
    overAllData.add(widget.photo['image1']);
    overAllData.add(widget.photo['image2']);
    overAllData.add(widget.photo['image3']);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF5F7FA),
      // appBar: AppBar(

        // title:  Text("Single Photo Details",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,),),backgroundColor:Color(0xFFF5F7FA),centerTitle: true,),

      // backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: 200,
            // leading: const BackButton(color: Colors.black),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.heart, color: Colors.black)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.more, color: Colors.black)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CarouselSlider(
                options: CarouselOptions(
                  height: 200.h,
                  viewportFraction: 1,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  aspectRatio: 16 / 9,
                  pageSnapping: true,
                  onPageChanged: (imgIndex, reason) {
                    setState(() {
                      _currentImageIndex = imgIndex;
                    });
                  },
                ),
                items: overAllData.map((url) {
                  return ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(4).r,
                    ),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 50),
                    ),
                  );
                }).toList(),
              ),
            ),
              // background: Image.network(
              //   "https://picsum.photos/500/300",
              //   fit: BoxFit.cover,
              // ),
            ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (overAllData.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(overAllData.length, (dotIndex) {
                        final isActive = _currentImageIndex == dotIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          width: isActive ? 10.w : 6.w,
                          height: isActive ? 10.h : 6.h,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.black : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  // Title + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Serenity Wellness Clinic",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text("Dental, Skin Care, Eye Care",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.star, size: 16, color: Colors.blue),
                            SizedBox(width: 4),
                            Text("4.8 (1k+ Review)",
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location + Time
                  Row(
                    children: const [
                      Icon(Iconsax.location, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "8502 Preston Rd, Inglewood, Maine 98380",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "15 min • 1.5km • Mon-Sun | 11 am - 11 pm",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      actionIcon(Iconsax.global, "Website"),
                      actionIcon(Iconsax.message, "Message"),
                      actionIcon(Iconsax.call, "Call"),
                      actionIcon(Iconsax.direct_right, "Direction"),
                      GestureDetector(
                          onTap: _shareApp2,
                          child: actionIcon(Iconsax.share, "Share")),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(height: 300,),

                  // Tab Section
                  DefaultTabController(
                    length: 4,
                    child: Column(
                      children: const [
                        TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: "Treatments"),
                            Tab(text: "Specialist"),
                            Tab(text: "Gallery"),
                            Tab(text: "Review"),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            children: [
                              TreatmentsList(),
                              Center(child: Text("Specialist")),
                              Center(child: Text("Gallery")),
                              Center(child: Text("Review")),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  Future<void> _shareApp2() async {
    try {
      // Download first product image
      final response = await http.get(Uri.parse(widget.photo['image1']));
      final bytes = response.bodyBytes;

      // Save to temp directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/product_image.jpg');
      await file.writeAsBytes(bytes);

      // Friendly customer message
      final message = """
Hello,  
I’m interested in this product.  

📌 Price: ${widget.photo['price'] ?? "N/A"}  
📝 Description: ${widget.photo['description'] ?? ""}  

Can you please confirm availability and details?  
""";

      // Share image + message
      await Share.shareXFiles(
        [XFile(file.path)],
        text: message,
      );
    } catch (e) {
      print("Error sharing: $e");
    }
  }

  Widget actionIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class TreatmentsList extends StatelessWidget {
  const TreatmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final treatments = ["Dental", "Skin Care", "Eye Care"];
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: treatments.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(treatments[index]),
        trailing: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }

}
