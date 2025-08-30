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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // Price + Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Flexible(
                          child: Text(
                            '₹$price',maxLines: 2,
                            style: TextStyle(overflow: TextOverflow.ellipsis,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Spacer(),
                        // Rating Badge
                        Container(
                          width: 34.w,
                          height: 34.w, // keep square
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4).r,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, size: 13.sp, color: Colors.amber),
                              SizedBox(width: 2.w),
                              Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
