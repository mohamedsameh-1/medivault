import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';

class BloodTypeSelector extends StatelessWidget {
  final String selectedBloodType;
  final ValueChanged<String> onChanged;

  const BloodTypeSelector({
    super.key,
    required this.selectedBloodType,
    required this.onChanged,
  });

  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: bloodTypes.map((bloodType) {
        final isSelected = selectedBloodType == bloodType;

        return GestureDetector(
          onTap: () => onChanged(bloodType),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 40.h,
            width: 60.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.primaryTealLight,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                bloodType,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.darkNavyText,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
