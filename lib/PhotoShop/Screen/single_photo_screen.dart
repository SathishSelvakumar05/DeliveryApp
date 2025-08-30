import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomerScreen/customer_share_screen.dart';
import '../Model/TableModel.dart';
import '../Widgets/ProductCard.dart';
import '../Widgets/SingleProduct.dart';
import '../Widgets/animation.dart';
import 'UploadMultiImage.dart';


class SinglePhotoScreen extends StatefulWidget {
  final List<TableModel>passedData;
  final String title;
  const SinglePhotoScreen({super.key,required this.passedData,required this.title});

  @override
  State<SinglePhotoScreen> createState() => _SinglePhotoScreenState();
}

class _SinglePhotoScreenState extends State<SinglePhotoScreen> {


  @override
  void initState() {
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFF5F7FA),
      appBar: AppBar(title:  Text("${widget.title} Collection",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold,),),backgroundColor:Color(0xFFF5F7FA),
        centerTitle: true,

      ),
      body:Column(
        mainAxisSize: MainAxisSize.min,
            children: [

              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,mainAxisExtent: 180,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                        ),
                        itemCount: widget.passedData.length,
                        itemBuilder: (context, index) {
                final photo = widget.passedData[index];
                bool isEven = index % 2 == 0; // even -> left to right, odd -> right to left
                return AnimationConfiguration.staggeredList(
                  position: index,
                  delay: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    horizontalOffset: isEven ? -50.0 : 50.0, // Direction based on index
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    child: FadeInAnimation(
                      child: FoodCard(
                        onTap: (){
                          print("hahah");
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>
                              PhotographerScreen(price: photo.price,description: photo.description,image1: photo.image1,image2: photo.image2,image3: photo.image3,),));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     ClinicDetailsScreen(photo: photo,),));
                        },
                        title: "${photo.description??""}",
                        price: "${photo.price}",
                        imageUrl: "${photo.image1}",
                      ),
                    ),
                  ),
                );
                // return FoodCard(
                //   onTap: (){
                //     print("hahah");
                //     // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                //     //     ClinicDetailsScreen(photo: photo,),));
                //   },
                //   title: "${photo.description??""}",
                //   price: "${photo.price}",
                //   imageUrl: "${photo.image1}",
                // );
                        },
                      ),
              ),
            ],
          ),
    );
  }
}


