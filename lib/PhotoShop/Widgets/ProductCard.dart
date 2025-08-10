import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatefulWidget {
  final String price;
  final String description;
  final List<dynamic> images;
  final bool autoPlay;

  const ProductCard({
    super.key,
    required this.price,
    required this.description,
    required this.images,
    required this.autoPlay,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20).r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12).r,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carousel for multiple images
          CarouselSlider(
            options: CarouselOptions(
              height: 200.h,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              enlargeCenterPage: false,
              autoPlay: widget.autoPlay,
              autoPlayInterval: const Duration(seconds: 3),
              aspectRatio: 16 / 9,
              pageSnapping: true,
              onPageChanged: (imgIndex, reason) {
                setState(() {
                  _currentImageIndex = imgIndex;
                });
              },
            ),
            items: widget.images.map((url) {
              return ClipRRect(
                borderRadius:  BorderRadius.vertical(
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

          // Dot indicators
          if (widget.images.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (dotIndex) {
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

          // Product details
          // Padding(
          //   padding: const EdgeInsets.all(3.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Center(
          //         child: Text("₹${widget.price}",
          //             style:  TextStyle(
          //                 fontWeight: FontWeight.bold, fontSize: 14.sp)),
          //       ),
          //        SizedBox(height: 4.h),
          //       Text(widget.description,style: TextStyle(fontSize: 10.sp),),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
