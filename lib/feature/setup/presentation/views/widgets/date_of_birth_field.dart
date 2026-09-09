import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

class DateOfBirthField extends StatelessWidget {
  final String date;
  final VoidCallback onTap;

  const DateOfBirthField({super.key, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 47.h,
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        decoration: BoxDecoration(
          color: AppColors.primaryTealLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18.sp,
              color: AppColors.secondaryGrey,
            ),
            SizedBox(width: 11.w),
            Text(date, style: AppStyles.w400S14Grey),
          ],
        ),
      ),
    );
  }
}
