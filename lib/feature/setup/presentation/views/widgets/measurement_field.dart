import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

class MeasurementField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String unit;
  final FormFieldValidator<String>? validator;

  const MeasurementField({
    super.key,
    required this.label,
    required this.controller,
    required this.unit,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.w600S13DisclaimerBold),

        SizedBox(height: 5.h),

        FormField<String>(
          validator: (value) => validator?.call(controller.text),
          builder: (formFieldState) {
            final hasError = formFieldState.hasError;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 47.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTealLight,
                    borderRadius: BorderRadius.circular(8.r),
                    border: hasError
                        ? Border.all(color: AppColors.red, width: 1)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        style: AppStyles.w600S14DarkNavy,
                        onChanged: (text) {
                          formFieldState.didChange(text);
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                        ),
                      ),
                      Positioned(
                        right: context.locale.languageCode == 'ar' ? null : 7.w,
                        left: context.locale.languageCode == 'ar' ? 7.w : null,
                        top: 11.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            unit,
                            style: AppStyles.w500S12BadgeGreen.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasError) ...[
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      formFieldState.errorText!,
                      style: TextStyle(color: AppColors.red, fontSize: 10.sp),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
