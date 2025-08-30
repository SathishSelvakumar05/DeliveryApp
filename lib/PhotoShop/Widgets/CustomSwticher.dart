import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitcher extends StatelessWidget {
  final String firstTitle;
  final String secondTitle;
  final bool isFirstSelected;
  final VoidCallback onFirstTap;
  final VoidCallback onSecondTap;

  const CustomSwitcher({
    Key? key,
    required this.firstTitle,
    required this.secondTitle,
    required this.isFirstSelected,
    required this.onFirstTap,
    required this.onSecondTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          // First Button
          Expanded(
            child: GestureDetector(
              onTap: onFirstTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isFirstSelected
                      ? const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: isFirstSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text(
                    firstTitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isFirstSelected ? Colors.white : Colors.black54,
                      fontWeight: isFirstSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Second Button
          Expanded(
            child: GestureDetector(
              onTap: onSecondTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: !isFirstSelected
                      ? const LinearGradient(
                    colors: [Color(0xFF0C1D37), Colors.lightBlueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: !isFirstSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text(
                    secondTitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: !isFirstSelected ? Colors.white : Colors.black54,
                      fontWeight: !isFirstSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
