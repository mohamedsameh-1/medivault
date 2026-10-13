import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';

class HomeSectionHeaderWidget extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onSeeAllTap;

  const HomeSectionHeaderWidget({
    super.key,
    required this.title,
    required this.count,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: AppStyles.w700S18DarkNavy),
        InkWell(
          onTap: onSeeAllTap,
          borderRadius: BorderRadius.circular(6.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${AppStrings.seeAll.tr()} ($count)',
                  style: AppStyles.w600S13PrimaryTeal,
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 14.sp,
                  color: AppColors.primaryTeal,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
