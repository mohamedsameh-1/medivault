import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String age;
  final String height;
  final String weight;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 12.h),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.bannerBg,
              ),
            ),
          ),

          SizedBox(height: 30.h),

          Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.lightTealBg,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                _InfoItem(title: 'profile.age'.tr(), value: age),
                _InfoItem(title: 'profile.height'.tr(), value: height),
                _InfoItem(title: 'profile.weight'.tr(), value: weight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 7.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkNavyText,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNavyText,
            ),
          ),
        ],
      ),
    );
  }
}
