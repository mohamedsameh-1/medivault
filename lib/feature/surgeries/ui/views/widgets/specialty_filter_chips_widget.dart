import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';

class SpecialtyFilterChipsWidget extends StatelessWidget {
  final List<String> specialties;
  final String selectedSpecialty;
  final ValueChanged<String> onSelected;

  const SpecialtyFilterChipsWidget({
    super.key,
    required this.specialties,
    required this.selectedSpecialty,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final specialty = specialties[index];
          final isSelected = specialty == selectedSpecialty;

          String displayTitle = specialty;
          if (specialty == 'All') {
            displayTitle = AppStrings.allSurgeries.tr();
          } else {
            final translationKey = 'specialties.$specialty.title';
            final translated = translationKey.tr();
            if (translated != translationKey) {
              displayTitle = translated;
            } else {
              displayTitle =
                  specialty[0].toUpperCase() +
                  specialty.substring(1).replaceAll('_', ' ');
            }
          }

          return GestureDetector(
            onTap: () => onSelected(specialty),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryTeal : AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryTeal
                      : AppColors.fieldBorder,
                  width: 1,
                ),
              ),
              child: Text(
                displayTitle,
                style: isSelected
                    ? AppStyles.w600S14PrimaryTeal.copyWith(
                        color: AppColors.white,
                        fontSize: 13.sp,
                      )
                    : AppStyles.w400S14Grey.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
