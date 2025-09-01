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
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../PhotoShop/Cubit/wedding_cubit.dart';
import '../../PhotoShop/Screen/UploadMultiImage.dart';
import '../../PhotoShop/Screen/single_photo_screen.dart';
import '../../PhotoShop/Widgets/CarouselSlider.dart';
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
  final supabase = Supabase.instance.client;
  List<dynamic> _photos = [];
  bool _loading = true;

  Future<void> _fetchPhotos() async {
   await context.read<WeddingCubit>().fetchWeddingPhotos();
   await context.read<KidsCubit>().fetchKidsPhotos();
   await context.read<CoupleCubit>().fetchCouplePhotos();
   await context.read<SingleCubit>().fetchSinglePhotos();
   await context.read<GroupCubit>().fetchGroupPhoto();
   await context.read<OfferCubit>().fetchOffersPhotos();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName = auth.currentUser?.displayName ?? "";
    photoUrl = auth.currentUser?.photoURL ?? "";
    print("skkkkkkkkk");
    print("${userName}");
    print("${photoUrl}");
    _fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location & Profile Row
              Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // background color
                    ),
                    child: ClipOval(
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "${userName}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                    Spacer(),
                  OpenContainer(
                    closedElevation: 0,
                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: const Duration(milliseconds: 500),
                    closedBuilder: (context, action) {
                      return  Padding(
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
                      );
                    },
                    openBuilder: (context, action) {
                      return const UploadMultiImage();
                    },
                  ),

                ],
              ),
              const SizedBox(height: 16),

              // Search Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Iconsax.search_normal),
                    hintText: "Search",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Upcoming Schedule
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Trending Offers",
                      style: TextStyle(
                          fontSize: 17.sp, fontWeight: FontWeight.bold)),
                ],
              ),
               SizedBox(height: 10.h),
              BlocBuilder<OfferCubit, OfferState>(
                builder: (context, state) {
                  if (state.isOfferLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.isOfferData!.isEmpty) {
                    return const Center(child: Text("No Offers Available"));
                  }

                  final lastOffer = state.isOfferData!.last;

                  // Collect only non-empty image URLs
                  final imageUrls = [
                    lastOffer.image1,
                    lastOffer.image2,
                    lastOffer.image3,
                  ].where((img) => img != null && img.trim().isNotEmpty).toList();

                  if (imageUrls.isEmpty) {
                    return const Center(child: Text("No Images Available"));
                  }

                  return ImageCarousel(
                    imageUrls: imageUrls,
                  );
                },
              ),
              //
              // SizedBox(height: 10.h),
              // Container(
              //   padding: const EdgeInsets.all(14).r,
              //   decoration: BoxDecoration(
              //     color: Color(0xFF0C1D37),
              //     borderRadius: BorderRadius.circular(16).r,
              //   ),
              //   child: Row(
              //     children: [
              //       Container(
              //         height: 50.h,
              //         width: 50.w,
              //         decoration: const BoxDecoration(
              //           color: Colors.white,
              //           shape: BoxShape.circle,
              //         ),
              //         child: const Icon(Iconsax.user, color: Colors.blue),
              //       ),
              //        SizedBox(width: 12.w),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: const [
              //             Text("S. Ram Kumar",
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold)),
              //             Text("VFX Editor",
              //                 style: TextStyle(color: Colors.white70)),
              //           ],
              //         ),
              //       ),
              //       Column(
              //         children: const [
              //           Text("Monday to Saturday",
              //               style: TextStyle(color: Colors.white)),
              //           Text("9 AM - 10 PM",
              //               style: TextStyle(color: Colors.white70)),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),

              // // Doctor Speciality
              // const Text("Doctor Speciality",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // const SizedBox(height: 10),
              // SizedBox(
              //   height: 80,
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: [
              //       specialityItem(Iconsax.user, "Dentist"),
              //       specialityItem(Iconsax.heart, "Cardiologist"),
              //       specialityItem(Iconsax.activity, "Orthopedic"),
              //       specialityItem(Iconsax.eye, "Neurologist"),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // Nearby Hospitals
              Row(
                children: [
                  Text("Wedding Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        final WeddingData=context.read<WeddingCubit>().state.weddingdata??[];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(title:"Wedding",passedData: WeddingData,),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<WeddingCubit, WeddingState>(
                builder: (context, state) {
                  if (state.isWeddingLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state.weddingdata!.isNotEmpty) {
                    return SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        itemCount: state.weddingdata!.length,
                        itemBuilder: (context, index) {
                          final photos = state.weddingdata![index];
                          final price = photos.price;
                          final imageUrl = photos.image1;
                          final desc = photos.description;
                          return hospitalCard(
                            price: price,
                            imageUrl: imageUrl,
                            description: desc,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: Text("Not available"),
                    );
                  }
                },
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),


              // Nearby Hospitals
              Row(
                children: [
                  Text("Kids Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        final kidsData=context.read<KidsCubit>().state.kidsData??[];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(title:"Kids",passedData: kidsData,),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<KidsCubit, KidsState>(
                builder: (context, state) {
                  if (state.isKidsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state.kidsData!.isNotEmpty) {
                    return SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        itemCount: state.kidsData!.length,
                        itemBuilder: (context, index) {
                          final photos = state.kidsData![index];
                          final price = photos.price;
                          final imageUrl = photos.image1;
                          final desc = photos.description;
                          return hospitalCard(
                            price: price,
                            imageUrl: imageUrl,
                            description: desc,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: Text("Not available"),
                    );
                  }
                },
              ),
              // Nearby Hospitals
              Row(
                children: [
                  Text("Couple Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        final coupleData=context.read<CoupleCubit>().state.coupleData??[];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(title:"Couple",passedData: coupleData,),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
        BlocBuilder<CoupleCubit, CoupleState>(
          builder: (context, state) {
            if (state.isCoupleLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (state.coupleData!.isNotEmpty) {
              return SizedBox(
                height: 110.h,
                child: ListView.builder(
                  itemCount: state.coupleData!.length,
                  itemBuilder: (context, index) {
                    final photos = state.coupleData![index];
                    final price = photos.price;
                    final imageUrl = photos.image1;
                    final desc = photos.description;
                    return hospitalCard(
                      price: price,
                      imageUrl: imageUrl,
                      description: desc,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                ),
              );
            }
            else {
              return const Center(
                child: Text("Not available"),
              );
            }
          },
              ),


              Row(
                children: [
                  Text("Single Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        final singleData=context.read<SingleCubit>().state.singleData??[];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(title:"Single",passedData: singleData,),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<SingleCubit, SingleState>(
                builder: (context, state) {
                  if (state.isSingleLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state.singleData!.isNotEmpty) {
                    return SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        itemCount: state.singleData!.length,
                        itemBuilder: (context, index) {
                          final photos = state.singleData![index];
                          final price = photos.price;
                          final imageUrl = photos.image1;
                          final desc = photos.description;
                          return hospitalCard(
                            price: price,
                            imageUrl: imageUrl,
                            description: desc,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: Text("Not available"),
                    );
                  }
                },
              ),

              Row(
                children: [
                  Text("Group Collections",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold)),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        final groupData=context.read<GroupCubit>().state.isGroupData??[];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SinglePhotoScreen(title:"Group",passedData: groupData,),
                            ));
                      },
                      child: Text(
                        "View more",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            color: Color(0xFF0C1D37)),
                      ))
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state.isGroupLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else if (state.isGroupData!.isNotEmpty) {
                    return SizedBox(
                      height: 110.h,
                      child: ListView.builder(
                        itemCount: state.isGroupData!.length,
                        itemBuilder: (context, index) {
                          final photos = state.isGroupData![index];
                          final price = photos.price;
                          final imageUrl = photos.image1;
                          final desc = photos.description;
                          return hospitalCard(
                            price: price,
                            imageUrl: imageUrl,
                            description: desc,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    );
                  }
                  else {
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

  Widget hospitalCard({required String price,required String imageUrl,required String description}) {
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


