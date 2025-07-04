import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'AddDelivery.dart';
import 'DeliveryScreen.dart';

class AddDeliveryTabs extends StatelessWidget {
  const AddDeliveryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        //backgroundColor: Constants.scaffBoldBgColor,
        backgroundColor:Color(0xFF1A2B45),
        appBar: AppBar(
          backgroundColor:  Color(0xFF1A2B45),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_bag,size: 30.sp,color: Colors.white,),
              tooltip: 'My Orders',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeliveryListScreen()),
                );
              },
            ),
            SizedBox(width: 10.w,),
          ],
          leading: IconButton(
            onPressed: () {
              // You can add navigation or drawer open logic here
            },
            icon: ClipOval(
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
              ),
            ),
          ),

          title: Text(
            "Delivery Tracking",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 6.0.sp),
              height: 40.h,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.0.sp)),
              child: TabBar(
                isScrollable: true,
                 tabAlignment: TabAlignment.start,
                indicator: BubbleTabIndicator(
                  tabBarIndicatorSize: TabBarIndicatorSize.label,
                  indicatorHeight: 30.h,
                  // padding: EdgeInsets.symmetric(horizontal: 1),
                  indicatorColor: Colors.white,indicatorRadius: 13,insets: EdgeInsets. symmetric(horizontal: 0),
                  // Padding for the underline
                ),
                labelColor: Colors.black,
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.white, // Unselected tab text color
                // labelColor: Theme.of(context).primaryColor, // Selected tab text color
                labelStyle: Theme.of(context).textTheme.labelLarge,
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Pickup & Drop',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store,
                            color: Colors.blue,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Purchase & Drop',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event,
                            color: Colors.purple,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Reservation',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DeliveryForm(type: "pickup_drop"),
                           DeliveryForm(type: "purchase_drop"),
                          DeliveryForm(type: "reservation"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
