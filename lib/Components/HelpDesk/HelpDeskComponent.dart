import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:info_popup/info_popup.dart';

class HelpDesk extends StatelessWidget {
  final String text;
  const HelpDesk({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InfoPopupWidget(
      contentTitle: text,
      child: Icon(Icons.help_outline,size: 18.sp,),
    );
  }
}