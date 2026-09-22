import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  const LanguageSelectionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLanguageCode = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.checkboxBorder,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'profile.select_language'.tr(),
            style: AppStyles.w600S16PrimaryTeal.copyWith(
              fontSize: 18.sp,
              color: AppColors.darkNavyText,
            ),
          ),
          SizedBox(height: 20.h),
          _LanguageTile(
            title: 'English',
            subtitle: 'English (US)',
            isSelected: currentLanguageCode == 'en',
            onTap: () async {
              if (currentLanguageCode != 'en') {
                await context.setLocale(const Locale('en'));
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 12.h),
          _LanguageTile(
            title: 'العربية',
            subtitle: 'Arabic',
            isSelected: currentLanguageCode == 'ar',
            onTap: () async {
              if (currentLanguageCode != 'ar') {
                await context.setLocale(const Locale('ar'));
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTeal.withValues(alpha: 0.1)
              : AppColors.lightTealBg.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.bannerBg,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.darkNavyText,
              size: 22.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.darkNavyText,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkNavyText.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryTeal,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
