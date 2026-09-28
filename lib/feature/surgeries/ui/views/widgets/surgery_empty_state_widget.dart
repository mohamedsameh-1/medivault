import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';

class SurgeryEmptyStateWidget extends StatelessWidget {
  const SurgeryEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Outer Glowing Circle Badge
            LottieBuilder.asset(AppAssets.emptyBoxLottie, height: 175.h),
            SizedBox(height: 32.h),
            Text(
              AppStrings.noSurgeriesRecordedYet.tr(),
              textAlign: TextAlign.center,
              style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 22.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.noSurgeriesRecordedDesc.tr(),
              textAlign: TextAlign.center,
              style: AppStyles.w400S14Grey.copyWith(
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }
}
