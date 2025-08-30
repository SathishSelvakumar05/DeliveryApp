import 'package:delivery_app/RBAC/service/PermissionService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/permission_cubit.dart';

class DriverScreen extends StatefulWidget {
  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool loading=false;
  @override
  void initState() {
    // TODO: implement initState
setRole();
    super.initState();
  }
  void setRole()async{
    setState(() {
      loading=true;
    });
    await Future.delayed(Duration(seconds: 5));
   await context.read<PermissionCubit>().loadPermissions();
    setState(() {
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Screen")),
      body: loading?Center(child: CircularProgressIndicator(),):Column(
        children: [
          // if (PermissionService.hasAccess(context,"driver", "GET"))
          //   Text(" You can view drivers"),
          //
          // if (PermissionService.hasAccess(context,"driver", "ADD"))
          //   ElevatedButton(onPressed: () {}, child: Text(" Add Driver")),
          //
          // if (PermissionService.hasAccess(context,"driver", "DELETE"))
          //   ElevatedButton(onPressed: () {}, child: Text(" Delete Driver")),
          //
          // if (!PermissionService.hasAccess(context,"trips", "Delete"))
            Text(" Can update trips"),

        ],
      ),
    );
  }
}
