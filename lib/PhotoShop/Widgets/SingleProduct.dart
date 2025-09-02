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


// class FoodCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String price;
//   final double rating;
//
//   const FoodCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.price,
//     this.rating = 4.9,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160.w,
//       margin: EdgeInsets.all(6.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Section with rating
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//             child: Stack(
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: imageUrl,
//                   height: 130.h,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) =>
//                   const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                   errorWidget: (context, url, error) =>
//                   const Icon(Icons.error, color: Colors.red),
//                 ),
//                 // Gradient at bottom for readability
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: 40.h,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Floating rating chip
//                 Positioned(
//                   top: 8.h,
//                   right: 8.w,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(20.r),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.star, size: 13.sp, color: Colors.amber),
//                         SizedBox(width: 2.w),
//                         Text(
//                           rating.toString(),
//                           style: TextStyle(
//                             fontSize: 11.sp,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Title + Price
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4.h),
//                 // Price Pill
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//                   decoration: BoxDecoration(
//                     color: Colors.blueAccent.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(30.r),
//                   ),
//                   child: Text(
//                     "Starts from ₹$price",
//                     style: TextStyle(
//                       fontSize: 11.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// class FoodCard extends StatelessWidget {
//   final String title;
//   final String price;
//   final String imageUrl;
//   final VoidCallback onTap;
//
//   const FoodCard({
//     Key? key,
//     required this.title,
//     required this.price,
//     required this.imageUrl,
//     required this.onTap,
//
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Section
//           SizedBox(
//             // height: 100,
//             child: ClipRRect(
//               borderRadius:  BorderRadius.only(
//                 topLeft: Radius.circular(10).r,
//                 topRight: Radius.circular(10).r,
//               ),
//               child: Stack(
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: imageUrl,
//                     height: 120.h,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Title
//           SizedBox(
//             height: 80.h,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     title.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       color: Colors.grey[700],
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
//                   // Price + Rating
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       // Price
//                       Flexible(
//                         child: Text(
//                           'Starts from ₹$price',maxLines: 2,
//                           style: TextStyle(overflow: TextOverflow.ellipsis,
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                       // Spacer(),
//                       // // Rating Badge
//                       // Container(
//                       //   width: 34.w,
//                       //   height: 34.w, // keep square
//                       //   decoration: BoxDecoration(
//                       //     color: Colors.amber.withOpacity(0.15),
//                       //     borderRadius: BorderRadius.circular(4).r,
//                       //   ),
//                       //   child: Row(
//                       //     mainAxisAlignment: MainAxisAlignment.center,
//                       //     children: [
//                       //       Icon(Icons.star, size: 13.sp, color: Colors.amber),
//                       //       SizedBox(width: 2.w),
//                       //       Text(
//                       //         '4.9',
//                       //         style: TextStyle(
//                       //           fontSize: 9.sp,
//                       //           fontWeight: FontWeight.w600,
//                       //           color: Colors.black87,
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//
//         ],
//       ),
//     );
//   }
// }
