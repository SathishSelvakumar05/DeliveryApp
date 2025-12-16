import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final double rating;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.rating = 4.9,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tap callback
      child: Container(
        width: 160.w,
        margin: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with rating
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
                  ),
                  // Gradient at bottom

                  // Floating rating chip
                  // Positioned(
                  //   top: 8.h,
                  //   right: 8.w,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white.withOpacity(0.9),
                  //       borderRadius: BorderRadius.circular(20.r),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black26,
                  //           blurRadius: 4,
                  //           offset: const Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.star, size: 13.sp, color: Colors.amber),
                  //         SizedBox(width: 2.w),
                  //         Text(
                  //           rating.toString(),
                  //           style: TextStyle(
                  //             fontSize: 11.sp,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.black87,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Title + Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  // Price Pill
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "Starts from ₹$price",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
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
