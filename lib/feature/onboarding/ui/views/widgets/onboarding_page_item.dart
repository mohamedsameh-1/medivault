import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import '../../model/onboarding_item.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPageItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          // Top SVG card container
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightTealBg,
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.all(16.w),
              child: SvgPicture.asset(item.svgAsset, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: 24.h),
          // Title
          Text(
            item.titleKey.tr(),
            style: AppStyles.w700S28DarkNavy,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          // Description
          Text(
            item.descKey.tr(),
            style: AppStyles.w400S14Grey,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
