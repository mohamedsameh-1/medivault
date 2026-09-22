import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_styles.dart';

import '../utils/app_colors.dart';

class AppBrandHeader extends StatelessWidget {
  final String subtitle;

  const AppBrandHeader({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.loginLogo4x, width: 50.w, height: 50.h),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'MediVault',
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style: AppStyles.w400S13Disclaimer.copyWith(
                    color: AppColors.bannerBg,
                    fontSize: 13.sp,
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
