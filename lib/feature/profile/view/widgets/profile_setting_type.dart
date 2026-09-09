import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ProfileSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;

  const ProfileSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.screenBg,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          constraints: BoxConstraints(minHeight: 55.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16.sp, color: AppColors.white),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkNavyText,
                      ),
                    ),

                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: AppColors.darkNavyText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (trailingText != null)
                Text(
                  trailingText!,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              SizedBox(width: 4.w),

              Icon(
                Icons.chevron_right,
                size: 16.sp,
                color: AppColors.darkNavyText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
