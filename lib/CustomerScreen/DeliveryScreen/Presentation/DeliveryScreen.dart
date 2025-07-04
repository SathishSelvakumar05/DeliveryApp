import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Cubit/add_delivery_cubit.dart';



class DeliveryListScreen extends StatelessWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryCubit, DeliveryState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Your Orders'),
            backgroundColor: const Color(0xfff5f5f5),
            elevation: 0,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon:Icon(Icons.arrow_back_rounded)),
          ),
          backgroundColor: const Color(0xfff5f5f5),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSection(
                    title: 'Pickup & Drop',
                    children: List.generate(state.pickupDropList.length, (index) {
                      final item = state.pickupDropList[index];
                      return ListTile(
                        title: Text("Description: ${item.description}"),
                        subtitle: Text("${item.source} → ${item.destination}"),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  _buildSection(
                    title: 'Purchase & Drop',
                    children: List.generate(state.purchaseDropList.length, (index) {
                      final item = state.purchaseDropList[index];
                      return ListTile(
                        title: Text("Description: ${item.description}"),
                        subtitle: Text(
                          "${item.source} → ${item.destination}\nStore: ${item.store}",
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  _buildSection(
                    title: 'Reservation',
                    children: List.generate(state.reservationList.length, (index) {
                      final item = state.reservationList[index];
                      return ListTile(
                        title: Text("Description: ${item.description}"),
                        subtitle: Text(
                          "${item.source} → ${item.destination}\nDate: ${item.reservationDate}, Time: ${item.reservationTime}",
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              )),
          SizedBox(height: 8.h),
          ...children,
        ],
      ),
    );
  }
}
