import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Widgets/ProductCard.dart';

class GetAllPhotos extends StatefulWidget {
  const GetAllPhotos({super.key});

  @override
  State<GetAllPhotos> createState() => _GetAllPhotosState();
}

class _GetAllPhotosState extends State<GetAllPhotos> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _allProducts = [];
  bool _loading = true;

  // Store current image index for each product
  final Map<int, int> _currentImageIndex = {};

  Future<void> _fetchPhotos() async {
    final response = await supabase
        .from('photos')
        .select('price, description, image1, image2, image3');

    setState(() {
      _allProducts = List<Map<String, dynamic>>.from(response);
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploaded Photos")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _allProducts.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _allProducts.length,
        itemBuilder: (context, index) {
          final product = _allProducts[index];

          // Collect non-null images into a list
          final images = [
            product['image1'],
            product['image2'],
            product['image3']
          ]
              .where((url) => url != null && url.isNotEmpty)
              .toList();

          return ProductCard(
            autoPlay: true,
            price: "${product['price']??"N/A"}",
            description: "${product['description'] ?? ''}",
            images:images
          );

          //   Card(
          //   elevation: 4,
          //   margin: const EdgeInsets.only(bottom: 12),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Carousel for multiple images
          //       CarouselSlider(
          //         options: CarouselOptions(
          //           height: 200,
          //           viewportFraction: 1,
          //           enableInfiniteScroll: true,
          //           enlargeCenterPage: false,
          //           autoPlay: true,
          //           autoPlayInterval: const Duration(seconds: 3),
          //           aspectRatio: 16 / 9,
          //           pageSnapping: true,
          //           onPageChanged: (imgIndex, reason) {
          //             setState(() {
          //               _currentImageIndex[index] = imgIndex;
          //             });
          //           },
          //         ),
          //         items: images.map((url) {
          //           return ClipRRect(
          //             borderRadius: const BorderRadius.vertical(
          //               top: Radius.circular(8),
          //             ),
          //             child: Image.network(
          //               url,
          //               fit: BoxFit.cover,
          //               width: double.infinity,
          //               errorBuilder: (context, error, stackTrace) =>
          //               const Icon(Icons.broken_image, size: 50),
          //             ),
          //           );
          //         }).toList(),
          //       ),
          //
          //       // Dot indicators
          //       if (images.length > 1)
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: List.generate(images.length, (dotIndex) {
          //             final isActive =
          //                 _currentImageIndex[index] == dotIndex;
          //             return AnimatedContainer(
          //               duration: const Duration(milliseconds: 300),
          //               margin:
          //               const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          //               width: isActive ? 10 : 6,
          //               height: isActive ? 10 : 6,
          //               decoration: BoxDecoration(
          //                 color: isActive
          //                     ? Colors.black
          //                     : Colors.grey,
          //                 shape: BoxShape.circle,
          //               ),
          //             );
          //           }),
          //         ),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("₹${product['price']}",
          //                 style: const TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 16)),
          //             const SizedBox(height: 4),
          //             Text(product['description'] ?? ''),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}
