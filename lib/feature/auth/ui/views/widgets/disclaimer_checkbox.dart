import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_styles.dart';

class DisclaimerCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const DisclaimerCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22.w,
            height: 22.h,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              side: const BorderSide(
                color: AppColors.checkboxBorder,
                width: 1.5,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                AppStrings.disclaimerText.tr(),
                style: AppStyles.w400S13Disclaimer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
