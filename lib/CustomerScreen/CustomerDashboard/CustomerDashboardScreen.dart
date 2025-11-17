import 'package:animations/animations.dart';
import 'package:delivery_app/PhotoShop/Cubit/CoupleCubit/couple_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/GroupCubit/group_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/OfferCubit/offer_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/SingleCubit/single_cubit.dart';
import 'package:delivery_app/PhotoShop/Cubit/kidsCubit/kids_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Components/AppBarComponents.dart';
// import '../../Firebase/EmailAccess.dart';
import '../../PhotoShop/Cubit/wedding_cubit.dart';
import '../../PhotoShop/Screen/UploadMultiImage.dart';
import '../../PhotoShop/Screen/single_photo_screen.dart';
import '../../PhotoShop/Widgets/CarouselSlider.dart';
import '../../PhotoShop/Widgets/SingleProduct.dart';
import '../../PhotoShop/Widgets/animation.dart';
import '../../main.dart';

class TryDashboard extends StatefulWidget {
  TryDashboard({super.key});

  @override
  State<TryDashboard> createState() => _TryDashboardState();
}

class _TryDashboardState extends State<TryDashboard> {
  String userName = '';
  String photoUrl = '';
bool isPermission=false;
String currentUserEmail='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<WeddingCubit>().fetchWeddingPhotos();
    // checkPermission();
    // userName = auth.currentUser?.displayName ?? "";
    // photoUrl = auth.currentUser?.photoURL ?? "";
    fetchcurrentUserEmail();
    print("skkkkkkkkk");
    print("${userName}");
    print("${photoUrl}");

  }
  fetchcurrentUserEmail()async{
    currentUserEmail= await auth.currentUser?.email??"";
    if(currentUserEmail.isNotEmpty){
      bool allowed = true;
      // bool allowed = await isEmailAllowed(currentUserEmail);

      if (allowed) {
        setState(() {
          isPermission=true;
        });
        print("Email is allowed ✅");
      } else {
        setState(() {
          isPermission=false;
        });
        print("Email is not allowed ❌");
      }    }
  }

//   checkPermission()async{
//     isPermission=await auth.currentUser?.email=="sathishkumar."
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBarWidget(
        titleText: "",
        isAppBarTitleWidgetNeed: true,isBackButtonNeeded: false,
        appBarTitle:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // background color
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/logo.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "VFX Advertisement",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Spacer(),
             // if(isPermission)
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadMultiImage(),));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
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
              )
            ],
          ),
        ),
        // Row(
        //   children: [
        //     CircleAvatar(
        //       backgroundColor: Colors.white,
        //       child: Icon(Icons.person, color: Colors.pinkAccent),
        //     ),
        //     SizedBox(width: 28.w),
        //     Text("Profile", style: TextStyle(color: Colors.white, fontSize: 18)),
        //   ],
        // ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Location & Profile Row

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    // Search Box
                    Row(
                      children: [
                        Expanded(
                          flex:8,
                          child: Container(
                            padding:  EdgeInsets.symmetric(horizontal: 12).r,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:  TextField(
                              decoration: InputDecoration(
                                icon: Icon(Iconsax.search_normal),
                                hintText: "Search",
                                border: InputBorder.none,
                              ),
                              onChanged: (val){
                                context.read<WeddingCubit>().filterByData(val.toLowerCase());
                              },

                            ),
                          ),
                        ),
                        SizedBox(width: 5.w,),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                showModalBottomSheet(context: context, builder: (context) {
                                  double start=12;
                                  double end=112;
                                  return _bottomSheetFilter(start: 10,end:200 );
                                },);
                              },
                              child: Container(
                                height: 43.h,
                                width: double.infinity,
                                  // padding:  EdgeInsets.symmetric(horizontal: 12).r,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.filter_alt_sharp,size: 30.sp,color: Color(0xFF0C1D37),)),
                            ))
                      ],
                    ),
                     SizedBox(height: 16.h),


                    SizedBox(height: 10.h),
                    BlocBuilder<OfferCubit, OfferState>(
                      builder: (context, state) {
                        if (state.isOfferLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state.isOfferData!.isEmpty) {
                          return const SizedBox();
                        }

                        final lastOffer = state.isOfferData!.last;

                        // Collect only non-empty image URLs
                        final imageUrls = [
                          lastOffer.image1,
                          lastOffer.image2,
                          lastOffer.image3,
                        ]
                            .where((img) => img != null && img.trim().isNotEmpty)
                            .toList();

                        if (imageUrls.isEmpty) {
                          return const Center(child: Text("Not Available"));
                        }

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Trending Offers",
                                    style: TextStyle(
                                        fontSize: 17.sp, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            ImageCarousel(
                              imageUrls: imageUrls,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Text("OverAll Collections",
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold)),
                        Spacer(),

                      ],
                    ),
                     SizedBox(height: 10.h),
                    BlocBuilder<WeddingCubit, WeddingState>(
                      builder: (context, state) {
                        if (state.isWeddingLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.weddingdata!.isNotEmpty) {
                          return SizedBox(
                            //height: 110.h,
                            child: GridView.builder(
                              padding: EdgeInsets.all(6).r,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(), // smooth scroll
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 cards per row
                                mainAxisSpacing: 12, // vertical spacing
                                crossAxisSpacing: 12, // horizontal spacing
                                childAspectRatio: 0.75, // control card height
                              ),
                              itemCount: state.weddingdata!.length,
                              itemBuilder: (context, index) {
                                final photos = state.weddingdata![index];
                                final price = photos.price;
                                final imageUrl = photos.image1;
                                final desc = photos.description;
                                bool isEven = index % 2 == 0;
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 400),
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              PhotographerScreen(
                                                price: price,
                                                description: desc,
                                                image1: imageUrl,
                                                image2: photos.image2,
                                                image3: photos.image3,
                                                isAutoMove: false,
                                              ),
                                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                            final offsetAnimation = Tween<Offset>(
                                              begin: const Offset(0.1, 0), // slight right
                                              end: Offset.zero,
                                            ).animate(animation);

                                            final fadeAnimation = CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut,
                                            );

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: FadeTransition(
                                                opacity: fadeAnimation,
                                                child: child,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    // onTap: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => PhotographerScreen(
                                  //           price: price,
                                  //           description: desc,
                                  //           image1: imageUrl,
                                  //           image2: photos.image2,
                                  //           image3: photos.image3,
                                  //           isAutoMove: false,
                                  //         ),
                                  //       ));
                                  // },
                                  child: AnimationConfiguration.staggeredList(
                                      position: index,
                                      delay: const Duration(milliseconds: 300),
                                      child: SlideAnimation(
                                          horizontalOffset: isEven
                                              ? -50.0
                                              : 50.0, // Direction based on index
                                          duration:
                                              const Duration(milliseconds: 1000),
                                          curve: Curves.easeOut,
                                          child: FoodCard(
                                            // onTap: () {},
                                            title: desc,
                                            price: price,
                                            imageUrl: imageUrl,
                                          ))

                                      ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("Not available"),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget specialityItem(IconData icon, String name) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
  _bottomSheetFilter({required double start,required double end}){
    return StatefulBuilder(
        builder: (context, setState) {
          return  Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RangeSlider(
                values: RangeValues(start, end),
                labels: RangeLabels(start.toString(), end.toString()),
                onChanged: (value) {
                  setState(() {
                    start = value.start;
                    end = value.end;
                  });
                },
                min: 10.0,
                max: 2000.0,
              ),
              Text(
                "Start: " +
                    start.toStringAsFixed(2) +
                    "\nEnd: " +
                    end.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ],
          );
        });
  }

  Widget hospitalCard(
      {required String price,
      required String imageUrl,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: EdgeInsets.only(right: 6),
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12).r,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)).r,
              child: Image.network(
                imageUrl,
                height: 60.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Price row with currency icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 12.sp, color: Colors.green),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Description row with info icon
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 10.sp, color: Colors.blueGrey),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      "${description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.black87,
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
