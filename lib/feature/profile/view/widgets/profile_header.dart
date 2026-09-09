import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_styles.dart';

import '../../../../core/utils/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.loginLogo4x, width: 40.w, height: 40.h),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MediVault',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'profile.title'.tr(),
                  style: AppStyles.w400S13Disclaimer.copyWith(
                    color: AppColors.bannerBg,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
