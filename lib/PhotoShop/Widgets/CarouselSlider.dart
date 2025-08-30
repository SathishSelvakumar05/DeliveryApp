import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const ImageCarousel({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.h, // Adjust height
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        enableInfiniteScroll: true,
      ),
      items: imageUrls.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      }).toList(),
    );
  }
}
