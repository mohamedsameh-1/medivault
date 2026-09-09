import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class DeleteAccountTile extends StatelessWidget {
  final VoidCallback? onTap;

  const DeleteAccountTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.screenBg,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          child: Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_remove_outlined,
                  size: 16.sp,
                  color: AppColors.red,
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile.delete_account'.tr(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.red,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'profile.delete_account_subtitle'.tr(),
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: AppColors.darkNavyText,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, size: 16.sp, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
