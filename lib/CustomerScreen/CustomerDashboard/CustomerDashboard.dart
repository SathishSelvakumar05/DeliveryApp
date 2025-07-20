import 'package:delivery_app/CustomerScreen/UserListScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remixicon/remixicon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../Components/Widgets/NoInternetScreen.dart';
import '../CustomerProfileScreen/Presentation/CustomerProfile.dart';
import '../DeliveryScreen/Presentation/AddDeliveryTabs.dart';
import '../DeliveryScreen/Presentation/DeliveryScreen.dart';
import 'CustomerDashboardScreen.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = "/DashBoard";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _bottomNavIndex;


  @override
  void initState() {
    _bottomNavIndex=0;
    // TODO: implement initState
    // _initializeBottomNavIndex();
    //getInitialData();
    super.initState();
  }

  // static Future<bool> requestNotificationPermission() async {
  //   PermissionStatus status = await Permission.notification.request();
  //   return status == PermissionStatus.granted;
  // }

  final iconList = <IconData>[
    Iconsax.home,
    Iconsax.document,
    Iconsax.dcube,
    Iconsax.category,
  ];
  // final autoSizeGroup = AutoSizeGroup();
  final _controller = SidebarXController(selectedIndex: 0, extended: true);



  Widget build(BuildContext context) {
    return  Scaffold(

        key: _scaffoldKey,
        // floatingActionButtonLocation: ExpandableFab.location,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        /* bottomNavigationBar: CurvedNavigationBar(
                  index: _bottomNavIndex,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  // buttonBackgroundColor: Constants.white,
                  height: 55.h,
                  animationCurve: Curves.decelerate,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  items: _navigationItem,
                  onTap: (index) {
                    setState(() {
                      _bottomNavIndex = index; // Update the index
                    });
                  },
                ),*/
        extendBody: true,

//                 floatingActionButton: _bottomNavIndex == 0
//                     ? FloatingActionButton(backgroundColor: Colors.white,
//                   onPressed: () {
// Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryListScreen(),));                  },
//                   child: Icon(Icons.add,color:  Color(0xFF0C1D37),),
//                 )
//                     : null,

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          height: 66.h,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => _buildNavItem(index)),
          ),
        ),
        body: _bottomNavIndex == 0
            ? AddDeliveryTabs()
            : _bottomNavIndex == 1
            ? CustomerDashboard()
            : _bottomNavIndex == 2
            ? CustomerProfile()
            :UserListScreen()
    );
      // BlocBuilder<InternetCubit, loading>(
      //   builder: (context, InternetState) {
      //     if (InternetState.checkInternet!) {
      //       if (_bottomNavIndex == null) {
      //         return Scaffold(
      //           body: const Center(
      //             child: CircularProgressIndicator(),
      //           ),
      //         );
      //       }
      //       return Scaffold(
      //         appBar: AppBar(
      //           centerTitle: true,title: Text('data'),
      //           actions: [],
      //           leading: SizedBox(),
      //         ),
      //         key: _scaffoldKey,
      //         backgroundColor: Color(0xfff5f5f5),
      //         extendBody: true,
      //         bottomNavigationBar: BottomAppBar(
      //           height: 66.h,
      //           color: Colors.white,
      //           shape: const CircularNotchedRectangle(),
      //           notchMargin: 10.r,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: List.generate(5, (index) => _buildNavItem(index)),
      //           ),
      //         ),
      //         body: _bottomNavIndex == 0
      //             ? UserListScreen()
      //             : _bottomNavIndex == 1
      //             ? UserListScreen()
      //             : _bottomNavIndex == 2
      //             ? UserListScreen()
      //             : _bottomNavIndex == 3
      //             ? UserListScreen()
      //             : UserListScreen(),
      //       );
      //     } else {
      //       return
      //       //   Scaffold(
      //       //   body: NoInternetConnection(),
      //       // );
      //     }
      //   });
  }

  Widget _buildNavItem(int index) {
    final isSelected = _bottomNavIndex == index;
    final icons = [
      // [Remix.id_card_line, Remix.id_card_fill],
      [Remix.dashboard_2_line, Remix.dashboard_2_fill],
      [Remix.home_6_line, Remix.home_6_fill],

      // [Remix.settings_2_line, Remix.settings_2_fill],
      [Remix.user_3_line, Remix.user_3_fill],
    ];
    final labels = [
      // 'Eagle View',
      // 'Vehicle List',
      'Dashboard',
      'Live Tracking',
      'Profile',
    ];

    return MaterialButton(
      minWidth: 50,
      onPressed: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? icons[index][1] : icons[index][0],
            color: isSelected ? Color(0xFF0C1D37) :Colors.black,
            size: 24.sp,
          ),
          SizedBox(height: 2.sp),
          Text(
            labels[index],
            style: TextStyle(
              fontSize: 8.sp,
              color: isSelected ? Color(0xFF0C1D37) : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Sheet extends StatelessWidget {
  final icons = [
    {
      "i": Remix.account_box_2_fill,
      "t": "Driver",
      "s": "No pending payments",
      "c": Colors.red,
      "screen": UserListScreen(),
    },
    {
      "i": Remix.circle_fill,
      "t": "Geofence",
      "s": "5 pending orders",
      "c": Colors.indigo,
      "screen": UserListScreen(),
    },
    {
      "i": Remix.history_fill,
      "t": "Historic Tracking",
      "s": "No pending payments",
      "c": Colors.blueGrey,
      "screen": UserListScreen(),
    },
    {
      "i": Remix.truck_fill,
      "t": "Trips",
      "s": "No pending payments",
      "c": Colors.purple,
      "screen": UserListScreen(),
    },
    {
      "i": Remix.notification_2_fill,
      "t": "Notification History",
      "s": "No pending payments",
      "c": Colors.brown,
      "screen": UserListScreen(),
    },
    {
      "i": Remix.bank_card_2_line,
      "t": "Reports",
      "s": "No pending payments",
      "c": Colors.green,
      "screen": UserListScreen(),
    },

  ];
  String? token;
  String? fcmToken;
  bool? logoutLoading = false;
  // void _showLogoutDialog(BuildContext context) {
  //   showDialog<String>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return PopScope(
  //             canPop: false,
  //             child: AlertDialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(12)).r,
  //               ),
  //               content: Text(
  //                 AppLocalizations.of(context)!.logoutConfirm,
  //                 style: TextStyle(fontSize: 16.sp),
  //               ),
  //               contentTextStyle: TextStyle(
  //                 color: Constants.black,
  //                 fontWeight: FontWeight.w500,
  //                 fontSize: 23.sp,
  //               ),
  //               actions: [
  //                 Center(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       OutlinedButton(
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                         style: ButtonStyle(
  //                           minimumSize:
  //                           WidgetStateProperty.all<Size>(Size(90.w, 40.h)),
  //                           shape:
  //                           WidgetStateProperty.all<RoundedRectangleBorder>(
  //                             RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0).r,
  //                             ),
  //                           ),
  //                           side: WidgetStateProperty.all<BorderSide>(
  //                             BorderSide(
  //                                 color: Color.fromRGBO(195, 210, 226, 1)),
  //                           ),
  //                         ),
  //                         child: Text(
  //                           AppLocalizations.of(context)!.no,
  //                           style: Theme.of(context).textTheme.bodySmall,
  //                         ),
  //                       ),
  //                       SizedBox(width: 25.w),
  //                       ElevatedButton(
  //                         onPressed: () async {
  //                           setState(() {
  //                             logoutLoading = true;
  //                           });
  //                           await _logoutAndNavigateToLoginScreen(context);
  //                           setState(() {
  //                             logoutLoading = false;
  //                           });
  //                         },
  //                         style: ButtonStyle(
  //                           minimumSize:
  //                           WidgetStateProperty.all<Size>(Size(90.w, 40.h)),
  //                           shape:
  //                           WidgetStateProperty.all<RoundedRectangleBorder>(
  //                             RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10.0).r,
  //                             ),
  //                           ),
  //                           backgroundColor: WidgetStateProperty.all<Color>(
  //                               Constants.secondary),
  //                         ),
  //                         child: logoutLoading!
  //                             ? SizedBox(
  //                           child: CircularProgressIndicator(
  //                             color: Constants.white,
  //                             strokeWidth: 3,
  //                           ),
  //                           height: 15.h,
  //                           width: 15.w,
  //                         )
  //                             : Text(
  //                           AppLocalizations.of(context)!.yes,
  //                           style:
  //                           Theme.of(context).textTheme.headlineSmall,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return DraggableScrollableSheet(
      builder: (context, controller) {
        return Material(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                height: 5.h,
                width: 60.w,
                margin: EdgeInsets.all(10).r,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20).r,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.all(10).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          for (var icon in icons)
                            GestureDetector(
                              onTap: () {
                                // Navigate to the appropriate screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    icon["screen"] as Widget,
                                  ),
                                );
                              },
                              child: FractionallySizedBox(
                                widthFactor: 0.33,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                      (icon["c"] as Color).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: [
                                      Icon(
                                        (icon["i"] as IconData),
                                        color: icon["c"] as Color,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "${icon["t"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.all(10.0).r,
                        child: Text(
                          "More Option",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Wrap(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserListScreen(),
                                ),
                              );
                            },
                            child: FractionallySizedBox(
                              widthFactor: 0.33,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Icon(
                                      Remix.settings_2_fill,
                                      color: Colors.black45,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Settings",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      minChildSize: 0.5,
      initialChildSize: 0.65,
      maxChildSize: 0.7,
    );
  }
}
