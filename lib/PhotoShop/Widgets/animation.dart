import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class PhotographerScreen extends StatefulWidget {
  final String price;
  final String description;
  final String image1;
  final String? image2;
  final String? image3;
  final bool? isAutoMove;
  const PhotographerScreen({
    super.key,
    required this.price,
    required this.description,
    required this.image1,
    this.image2,
    this.image3,
    this.isAutoMove=true
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
        title:  Text(
          "Product Details",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel with dots
          Expanded(flex: 7,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 540.h,
                autoPlay: widget.isAutoMove??false,
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
                  child:  PhotoView(enableRotation: true,
                    backgroundDecoration: const BoxDecoration(color: Colors.transparent),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3, // up to 3x zoom
                    imageProvider: CachedNetworkImageProvider(url),
                    loadingBuilder: (context, event) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.red),
                  ),
                  // CachedNetworkImage(
                  //   imageUrl: url,
                  //   // height: 120.h,
                  //   width: double.infinity,
                  //   fit: BoxFit.scaleDown,
                  //   placeholder: (context, url) => Center(
                  //     child: CircularProgressIndicator(strokeWidth: 2),
                  //   ),
                  //   errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                  // ),

                );
              }).toList(),
            ),
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

          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white, // Flipkart style -> white card
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Row with Discount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Starts from",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color:  Colors.black, // Flipkart dark blue
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          "₹${widget.price}",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0C1D37), // Flipkart dark blue
                          ),
                        ),
                        // SizedBox(width: 6.w),
                        // Text(
                        //   "₹9999", // Example MRP, you can replace with widget.mrp
                        //   style: TextStyle(
                        //     fontSize: 14.sp,
                        //     color: Colors.grey,
                        //     decoration: TextDecoration.lineThrough,
                        //   ),
                        // ),
                        // SizedBox(width: 6.w),
                        // Text(
                        //   "35% OFF", // Example discount, pass dynamically
                        //   style: TextStyle(
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.green.shade700,
                        //   ),
                        // ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Highlight Badge (like Flipkart "Assured" or tag)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Best Deal", // replace with dynamic highlight if needed
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Description
                    Flexible(
                      child: Text(
                        "${widget.description.toUpperCase()}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

//
//           // Price
//           // Price
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   "Starts from ",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF0C1D37), // dark background
//                     borderRadius: BorderRadius.circular(8.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.15),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         "₹", // Indian Rupee Symbol
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: 2.w),
//                       Text(
//                         widget.price,
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//
// // Description
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
//             child: Text(
//               widget.description,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey.shade800,
//                 height: 1.5,
//               ),
//             ),
//           ),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // actionIcon(Iconsax.global, "Website"),
              GestureDetector(
                  onTap: (){
                    sendSMS("+919345867913");
                  },
                  child: actionIcon(Iconsax.message, "Message")),
              GestureDetector(
                onTap: (){
                  callNumber("+919345867913");

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
          SizedBox(height: 50.h,)

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
🎨 Turn your photos into masterpieces – only on Vfz APP!  
Download now: https://play.google.com/store/apps/details?id=com.yourapp
 
""";
      // Friendly customer message
//       final message = """
// Hello,
// I’m interested in this product.
//
// 📌 Price: ${widget.price?? "N/A"}
// 📝 Description: ${widget.description ?? ""}
//
// Can you please confirm availability and details?
// """;

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
