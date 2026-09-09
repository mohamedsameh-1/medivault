import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

class MeasurementField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String unit;

  const MeasurementField({
    super.key,
    required this.label,
    required this.controller,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.w600S13DisclaimerBold),

        SizedBox(height: 5.h),

        Container(
          height: 47.h,
          decoration: BoxDecoration(
            color: AppColors.primaryTealLight,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: AppStyles.w600S14DarkNavy,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                ),
              ),

              Positioned(
                right: 7.w,
                top: 11.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
      ],
    );
  }
}
