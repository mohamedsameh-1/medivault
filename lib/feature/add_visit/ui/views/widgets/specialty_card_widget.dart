import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import '../models/specialty_model.dart';

class SpecialtyCardWidget extends StatelessWidget {
  final SpecialtyModel specialty;
  final bool isSelected;
  final VoidCallback onTap;

  const SpecialtyCardWidget({
    super.key,
    required this.specialty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.badgeGreenBg,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryTeal.withOpacity(0.12),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6.r,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Color Tint and Specialty Icon
              SizedBox(
                height: 100.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Specialty Icon / Image
                    Center(
                      child: Image.asset(
                        specialty.iconPath,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback built-in icon if asset image is not yet provided
                          return Icon(
                            Icons.medical_services_outlined,
                            size: 32.r,
                            color: AppColors.bannerBg,
                          );
                        },
                      ),
                    ),
                    // Selection indicator checkmark/dot at top left if selected
                    if (isSelected)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          width: 14.r,
                          height: 14.r,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 10.r,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Body Content (Title & Description)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        specialty.title.tr(),
                        style: AppStyles.w600S14DarkNavy.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        specialty.description.tr(),
                        style: AppStyles.w400S14Grey.copyWith(
                          fontSize: 11.sp,
                          height: 1.2.h,
                          color: AppColors.secondaryGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
