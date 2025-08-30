import 'package:delivery_app/RBAC/enum/RBACenums.dart';
import 'package:flutter/material.dart';

import '../service/PermissionService.dart';

class RBDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (PermissionService.hasAccess(context, ModuleType.liveDashboard, AccessType.GET))
              ElevatedButton(onPressed: () {}, child: Text("GET Data")),

            if (PermissionService.hasAccess(context,  ModuleType.liveDashboard, AccessType.ADD))
              ElevatedButton(onPressed: () {}, child: Text("ADD Data")),

            if (PermissionService.hasAccess(context, ModuleType.liveDashboard, AccessType.UPDATE))
              ElevatedButton(onPressed: () {}, child: Text("UPDATE Data")),

            if (PermissionService.hasAccess(context, ModuleType.liveDashboard, AccessType.DELETE))
              ElevatedButton(onPressed: () {}, child: Text("DELETE Data")),
          ],
        ),
      ),
    );
  }
}
