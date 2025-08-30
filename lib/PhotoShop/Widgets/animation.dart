import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class PhotographerScreen extends StatefulWidget {
  final String price;
  final String description;
  final String image1;
  final String? image2;
  final String? image3;

  const PhotographerScreen({
    super.key,
    required this.price,
    required this.description,
    required this.image1,
    this.image2,
    this.image3,
  });

  @override
  State<PhotographerScreen> createState() => _PhotographerScreenState();
}

class _PhotographerScreenState extends State<PhotographerScreen> {
  late List<String> images; // store filtered images
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Filter images once during initialization
    images = [
      widget.image1,
      widget.image2 ?? "",
      widget.image3 ?? "",
    ].where((url) => url.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Photoshoot Package",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel with dots
          CarouselSlider(
            options: CarouselOptions(
              height: 240.h,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.95,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: images.map((url) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),

          // Dots Indicator
         if(images.length>1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              bool isActive = _currentIndex == entry.key;
              return Container(
                width: isActive ? 10.w : 8.w,
                height: isActive ? 10.w : 8.w,
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.black87 : Colors.grey,
                ),
              );
            }).toList(),
          ),

          // Price
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Text(
              widget.price,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              widget.description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              actionIcon(Iconsax.global, "Website"),
              GestureDetector(
                  onTap: (){
                    sendSMS("+919585394516");
                  },
                  child: actionIcon(Iconsax.message, "Message")),
              GestureDetector(
                onTap: (){
                  callNumber("+919595394516");

                },
                  child: actionIcon(Iconsax.call, "Call")),
              GestureDetector(
                  onTap: () => openMap(13.0827, 80.2707),
                  child: actionIcon(Iconsax.direct_right, "Direction")),
              GestureDetector(
                  onTap: _shareApp2,
                  child: actionIcon(Iconsax.share, "Share")),
            ],
          ),

        ],
      ),
    );
  }
  Future<void> _shareApp2() async {
    try {
      // Download first product image
      final response = await http.get(Uri.parse(widget.image1));
      final bytes = response.bodyBytes;

      // Save to temp directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/product_image.jpg');
      await file.writeAsBytes(bytes);

      // Friendly customer message
      final message = """
Hello,  
I’m interested in this product.  

📌 Price: ${widget.price?? "N/A"}  
📝 Description: ${widget.description ?? ""}  

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

  Future<void> callNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
  Future<void> openMap(double lat, double long) async {
    final Uri mapUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$long");
    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch map for $lat,$long';
    }
  }
  Future<void> sendSMS(String phoneNumber, {String? message}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS to $phoneNumber';
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
