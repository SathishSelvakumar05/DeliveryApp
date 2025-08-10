import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomerScreen/customer_share_screen.dart';
import '../Widgets/ProductCard.dart';
import '../Widgets/SingleProduct.dart';
import 'UploadMultiImage.dart';


class SinglePhotoScreen extends StatefulWidget {
  const SinglePhotoScreen({super.key});

  @override
  State<SinglePhotoScreen> createState() => _SinglePhotoScreenState();
}

class _SinglePhotoScreenState extends State<SinglePhotoScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> _photos = [];
  bool _loading = true;

  Future<void> _fetchPhotos() async {
    final response = await supabase.from('photos').select();
    setState(() {
      _photos = response;
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
      backgroundColor:Color(0xFFF5F7FA),
      appBar: AppBar(title:  Text("Wedding Collection",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,),),backgroundColor:Color(0xFFF5F7FA),
        centerTitle: true,actions: [
          Padding(
            padding:  EdgeInsets.only(right: 20).r,
            child: InkWell(
              borderRadius: BorderRadius.circular(30).r,
              onTap: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => UploadMultiImage(),));             },
              child: CircleAvatar(
                radius: 20.sp,
                backgroundColor: Colors.pink.shade400,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Expanded(
                child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,mainAxisExtent: 180,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                        ),
                        itemCount: _photos.length,
                        itemBuilder: (context, index) {
                final photo = _photos[index];
                return FoodCard(
                  onTap: (){
                    print("hahah");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClinicDetailsScreen(photo: photo,),));
                  },
                  title: "${photo['description']??""}",
                  price: "${photo['price']}",
                  imageUrl: "${photo['image1']}",
                );
                        },
                      ),
              ),
            ],
          ),
    );
  }
}


