import 'package:delivery_app/RBAC/enum/RBACenums.dart';
import 'package:flutter/material.dart';

import '../service/PermissionService.dart';
import 'RBDashboard.dart';
import 'RBDriver.dart';
import 'RBTrips.dart';


class RoleBasedDashboard extends StatefulWidget {
  const RoleBasedDashboard({Key? key}) : super(key: key);

  @override
  State<RoleBasedDashboard> createState() => _RoleBasedDashboardState();
}

class _RoleBasedDashboardState extends State<RoleBasedDashboard> {
  int _currentIndex = 0;
  late List<BottomNavigationBarItem> _items;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _items = [];
    _screens = [];

    if (PermissionService.hasAccess(context, ModuleType.liveDashboard,AccessType.GET)) {
      _items.add(BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"));
      _screens.add(RBDashboard());
    }

    if (PermissionService.hasAccess(context, ModuleType.trips, AccessType.GET)) {
      _items.add(BottomNavigationBarItem(icon: Icon(Icons.trip_origin), label: "Trips"));
      _screens.add(RBTrips());
    }

    if (PermissionService.hasAccess(context,ModuleType.driver, AccessType.GET)) {
      _items.add(BottomNavigationBarItem(icon: Icon(Icons.person), label: "Drivers"));
      _screens.add(RBDriverScreen());
    }

    if (_items.isEmpty) {
      _items = [
        const BottomNavigationBarItem(icon: Icon(Icons.block), label: "No Access")
      ];
      _screens = [Scaffold(body: Center(child: Text("No access available")))];
    } else if (_items.length == 1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print("Frame rendered at $timeStamp");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => _screens.first),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _items.length < 2
          ? null
          : BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _items,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}


