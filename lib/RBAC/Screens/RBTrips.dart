import 'package:delivery_app/PhotoShop/Screen/UploadMultiImage.dart';
import 'package:flutter/material.dart';

import '../Widgets/RBPopUpWidget.dart';
import '../enum/RBACenums.dart';
import '../service/PermissionService.dart';

class RBTrips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trips")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (PermissionService.hasAccess(context, ModuleType.trips, AccessType.GET))
              ListTile(title: Text("You can view Trips"),trailing: PermissionPopupMenu(
                module: ModuleType.trips,
                onAdd: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadMultiImage(),));
                  print("Add clicked on Trips");
                },
                onUpdate: () {
                  print("Update clicked on Trips");
                },
                onDelete: () {
                  print("Delete clicked on Trips");
                },
              )),
            if (PermissionService.hasAccess(context,ModuleType.trips, AccessType.ADD))
              ElevatedButton(onPressed: () {}, child: Text("Add Trip")),

            if (PermissionService.hasAccess(context,ModuleType.trips, AccessType.UPDATE))
              ElevatedButton(onPressed: () {}, child: Text("Update Trip")),

            if (PermissionService.hasAccess(context,ModuleType.trips, AccessType.DELETE))
              ElevatedButton(onPressed: () {}, child: Text("Delete Trip")),
          ],
        ),
      ),
    );
  }
}
