import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  const FoodCard({
    Key? key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        surfaceTintColor: Colors.blue,
        shadowColor:Colors.black54,color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10).r),
        elevation: 2,
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(10).r,
                topRight: Radius.circular(10).r,
              ),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 6,
                    right:6,
                    child:
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding:  EdgeInsets.all(6).r,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(
                          Icons.fullscreen,
                          size: 18.sp,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 2, right: 8),
              child: Text(
                title,
                style:  TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
// SizedBox(height: 20.h,),
            // Price + Rating Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹$price',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 2),
                      Text(
                        '4.8',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
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
