import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../Utils/Constants/TextConstants.dart';
import '../../Utils/Constants/TextStyles.dart';
import '../Button/CustomButton.dart';

class NoDataFound extends StatelessWidget {
  final String? text;
  final int? height;
  final int? width;
  final String? lottie;
  final Function? refreshFunction;

  const NoDataFound(
      {super.key,
      this.text = 'No Data Found',
      this.height = 350,
      this.width = 300,
      this.lottie,
      this.refreshFunction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(lottie!, height: height!.h),
          Text(
            text!,
            style: TextStyleClass.textSize17Bold(color:Theme.of(context).hintColor),
          ),
          SizedBox(
            height: 15.h,
          ),
          CustomElevatedButton(
              text: TextConstants.refresh,
              onPressed: () {
                if (refreshFunction != null) {
                  refreshFunction!();
                }
              }),
        ],
      ),
    );
  }
}
