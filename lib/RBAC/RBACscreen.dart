//
// // Step 1: Define roles with permissions
// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'cubit/permission_cubit.dart';
//
// class Roles {
//   static const admin = "admin";
//   static const editor = "editor";
//   static const viewer = "viewer";
// }
//
// // Step 2: Simulate logged-in user role
// String currentUserRole = Roles.admin; // change to admin/viewer to test
//
// // Step 3: Permission check function
// bool hasPermission(String action) {
//   final rolePermissions = {
//     Roles.admin: ["create", "read", "update", "delete"],
//     Roles.editor: ["create", "read", "update"],
//     Roles.viewer: ["read"],
//   };
//
//   return rolePermissions[currentUserRole]?.contains(action) ?? false;
// }
//
// class RBACscreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("RBAC Example in Flutter"),
//         leading: GestureDetector(
//           onTap: ()=>
//             Navigator.pop(context),
//             child: Icon(Icons.arrow_back)),),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Current Role: $currentUserRole"),
//
//               // Viewer can only read
//               if (hasPermission("read"))
//                 Text("📖 You can READ data"),
//
//               // Editor/Admin can update
//               if (hasPermission("update"))
//                 ElevatedButton(
//                   onPressed: () {},
//                   child: Text("✏️ Update Data"),
//                 ),
//
//               // Only Admin can delete
//               if (hasPermission("delete"))
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   child: Text("🗑️ Delete Data"),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
// late List<FeatureResponse> features;
//
// bool hasAccess(String moduleName, String action) {
//   for (var feature in features) {
//     for (var module in feature.modules) {
//       if (module.moduleName.toLowerCase() == moduleName.toLowerCase()) {
//         return module.accessType.contains(action);
//       }
//     }
//   }
//   return false;
// }
//
// class PermissionDemoScreen extends StatefulWidget {
//   @override
//   State<PermissionDemoScreen> createState() => _PermissionDemoScreenState();
// }
//
// class _PermissionDemoScreenState extends State<PermissionDemoScreen> {
//   @override
//   void initState() {
//     super.initState();
//
//     final jsonMap = jsonDecode(backendResponse);
//     features = (jsonMap['featureResponseList'] as List)
//         .map((f) => FeatureResponse.fromJson(f))
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("RBAC Demo with Backend")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Driver Module:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (hasAccess("driver", "GET"))
//               Text("✅ You can view drivers"),
//             if (hasAccess("driver", "ADD"))
//               ElevatedButton(onPressed: () {}, child: Text("➕ Add Driver")),
//             if (hasAccess("driver", "DELETE"))
//               ElevatedButton(onPressed: () {}, child: Text("🗑️ Delete Driver")),
//             if (!hasAccess("driver", "UPDATE"))
//               Text("❌ Cannot update drivers"),
//
//             Divider(),
//
//             Text("Trips Module:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (hasAccess("trips", "GET")) Text("✅ You can view trips"),
//             if (hasAccess("trips", "ADD"))
//               ElevatedButton(onPressed: () {}, child: Text("➕ Add Trip")),
//             if (hasAccess("trips", "DELETE"))
//               ElevatedButton(onPressed: () {}, child: Text("🗑️ Delete Trip")),
//             if (!hasAccess("trips", "UPDATE"))
//               Text("❌ Cannot update trips"),
//
//             Divider(),
//
//             Text("Reports Module:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (hasAccess("reports", "GET")) Text("✅ You can view reports"),
//             if (hasAccess("reports", "ADD"))
//               ElevatedButton(onPressed: () {}, child: Text("📊 Add Report")),
//             if (!hasAccess("reports", "DELETE"))
//               Text("❌ Cannot delete reports"),
//
//             Divider(),
//
//             Text("Live Dashboard Module:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             if (hasAccess("live dashboard", "GET"))
//               Text("✅ You can view live dashboard"),
//             if (!hasAccess("live dashboard", "ADD"))
//               Text("❌ Cannot add in dashboard"),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
