
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:remixicon/remixicon.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../PhotoShop/Cubit/wedding_cubit.dart';
import '../CustomerProfileScreen/Presentation/CustomerProfile.dart';
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
    super.initState();
    context.read<WeddingCubit>().fetchWeddingPhotos();

  }


  final iconList = <IconData>[
    Iconsax.home,
    Iconsax.document,
    Iconsax.dcube,
    Iconsax.category,
  ];




  Widget build(BuildContext context) {
    return  Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          height: 66.h,
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(2, (index) => _buildNavItem(index)),
          ),
        ),
        body: _bottomNavIndex == 0
            ? TryDashboard()
            : _bottomNavIndex == 1
            ? CustomerProfile()
            : _bottomNavIndex == 2
            ?TryDashboard():
        // ClinicDetailsScreen():
        CustomerProfile()

    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = _bottomNavIndex == index;
    final icons = [
      // [Remix.id_card_line, Remix.id_card_fill],
      [Remix.dashboard_2_line, Remix.dashboard_2_fill],
      // [Remix.home_6_line, Remix.home_6_fill],

      // [Remix.settings_2_line, Remix.settings_2_fill],
      [Remix.user_3_line, Remix.user_3_fill],
    ];
    final labels = [
      // 'Eagle View',
      // 'Vehicle List',
      'Dashboard',
      // 'Live Tracking',
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





