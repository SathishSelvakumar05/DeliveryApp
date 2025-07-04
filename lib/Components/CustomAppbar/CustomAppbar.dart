import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/Constants/TextStyles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? isBackFunction;
  final Function? backFunction;
  final bool isDashBoard;
  final Widget? actions;

  const CustomAppBar(
      {super.key,
      this.title = "",
      this.isDashBoard = false,
      this.isBackFunction = false,
      this.backFunction,
      this.actions})
      : preferredSize = const Size.fromHeight(kToolbarHeight);
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.3,
     backgroundColor: Colors.transparent,
     // backgroundColor: Theme.of(context).primaryColor,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyleClass.textSize18(color: Theme.of(context).hintColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: isDashBoard == true
          ? const SizedBox()
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                // color: Colors.black,
              ),
              onPressed: () => isBackFunction!
                  ? backFunction!()
                  : Navigator.of(context).pop(),
            ),
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 15.0).r,
                child: actions!,
              )
            ]
          : [],
    );
  }
}
