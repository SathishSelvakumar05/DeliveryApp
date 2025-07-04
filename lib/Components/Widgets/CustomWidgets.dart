import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/Constants/ColorConstants.dart';
import '../../Utils/Constants/TextConstants.dart';
import '../../Utils/Constants/TextStyles.dart';
import '../CustomToast/CustomToast.dart';

class CustomWidgets {
  showLogoutDialog(BuildContext context, {bool isValidRole = true}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          TextConstants.logout,
          style:
              TextStyleClass.textSize17Bold(color: Theme.of(context).hintColor),
        ),
        content: Text(
          TextConstants.logoutMsg,
          style: TextStyleClass.textSize15(color: Theme.of(context).hintColor),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(TextConstants.cancel,
                style: TextStyleClass.textSize14Bold(
                    color: Theme.of(context).hintColor)),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => logoutFunction(context, isValidRole),
            child: Text(TextConstants.logout,
                style:
                    TextStyleClass.textSize14Bold(color: KConstantColors.red)),
          ),
        ],
      ),
    );
  }

  goBackDialog(BuildContext context) {
    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text("Are you sure you want to go back?"),
        actions: [
          CupertinoDialogAction(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () =>
                  {Navigator.pop(context), Navigator.pop(context)}),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // Widget roles(
  //   BuildContext context,
  //   String role,
  // ) {
  //   switch (role.toString().toLowerCase()) {
  //     case TextConstants.inspectionStaff:
  //       return VehicleScreen();
  //     // case TextConstants.customerAdmin:
  //     //   return const VehicleScreen();
  //     default:
  //       return Scaffold(
  //         body: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Center(
  //               child: GestureDetector(
  //                 onTap: () {
  //                   CustomWidgets()
  //                       .showLogoutDialog(context, isValidRole: false);
  //                 },
  //                 child: Container(
  //                   width: 55.w,
  //                   height: 55.w,
  //                   decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Colors.white,
  //                       border: Border.all(color: Colors.green.shade800)),
  //                   child: Icon(
  //                     Icons.logout_outlined,
  //                     color: Colors.black,
  //                     size: 25.sp,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20.h,
  //             ),
  //             Center(
  //               child: Text(TextConstants.unknownRole),
  //             ),
  //           ],
  //         ),
  //       );
  //   }
  // }

  Future<void> logoutFunction(BuildContext context, isValidRole) async {
    try {
      // if (isValidRole) {
      //   await context
      //       .read<LoginCubit>()
      //       .LogoutCubit(context.read<LoginCubit>().authToken!);
      // }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      showSuccessToast(TextConstants.loggedOutSuccessfully);
      // Navigator.pop(context);
      // Navigator.(
      //   context,
      //   MaterialPageRoute(builder: (context) => const LoginScreen()),
      //   (Route<dynamic> route) => false,
      // );
    } on DioException catch (e) {
      showErrorToast(e.response?.data['error'] ?? e.response?.data['message']);
    }
  }
}
