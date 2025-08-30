import 'package:flutter/material.dart';

import '../Widgets/RBPopUpWidget.dart';
import '../enum/RBACenums.dart';
import '../service/PermissionService.dart';

class RBDriverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drivers")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (PermissionService.hasAccess(context, ModuleType.driver, AccessType.GET))
              ListTile(title: Text("You can view drivers"),trailing: PermissionPopupMenu(
                module: ModuleType.driver,
                onAdd: () {
                  print("Add clicked on driver");
                },
                onUpdate: () {
                  print("Update clicked on driver");
                },
                onDelete: () {
                  print("Delete clicked on driver");
                },
              )),

            if (PermissionService.hasAccess(context,  ModuleType.driver, AccessType.ADD))
              ElevatedButton(onPressed: () {}, child: Text("Add Driver")),



            if (PermissionService.hasAccess(context, ModuleType.driver, AccessType.DELETE))
              ElevatedButton(onPressed: () {}, child: Text("Delete Driver")),

            if (PermissionService.hasAccess(context, ModuleType.driver, AccessType.UPDATE))
              ElevatedButton(onPressed: () {}, child: Text("Can Update Driver")),
          ],
        ),
      ),
    );
  }
}
