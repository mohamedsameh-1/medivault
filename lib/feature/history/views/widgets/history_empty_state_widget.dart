import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';

class HistoryEmptyStateWidget extends StatelessWidget {
  final SpecialtyModel specialty;

  const HistoryEmptyStateWidget({super.key, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AppAssets.emptyBoxLottie, width: 200.w, height: 200.h),
          SizedBox(height: 24.h),
          Text(
            AppStrings.noVisitsRecordedYet.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.noVisitsRecordedDesc.tr(),
            textAlign: TextAlign.center,
            style: AppStyles.w400S14Grey.copyWith(fontSize: 13.sp, height: 1.5),
          ),
        ],
      ),
    );
  }
}
