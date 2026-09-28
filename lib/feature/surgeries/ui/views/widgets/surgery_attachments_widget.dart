import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';

class SurgeryAttachmentsWidget extends StatelessWidget {
  final VoidCallback? onTakePhoto;
  final VoidCallback? onChooseFile;

  const SurgeryAttachmentsWidget({
    super.key,
    this.onTakePhoto,
    this.onChooseFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.medicalAttachments.tr(),
          style: AppStyles.w600S14DarkNavy.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTakePhoto,
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.fieldBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryTeal,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppStrings.takePhoto.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: onChooseFile,
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.fieldBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.insert_drive_file_outlined,
                        color: AppColors.primaryTeal,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        AppStrings.chooseFile.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Mock Attached Items List (UI Only)
        // _AttachmentItemCard(
        //   fileName: 'Dr._Ahmed_Prescription_Rx.jpg',
        //   fileInfo: 'Rx Photo · 1.4 MB',
        //   icon: Icons.assignment_outlined,
        //   iconBgColor: const Color(0xFFE0F2F1),
        //   iconColor: AppColors.primaryTeal,
        // ),
        // SizedBox(height: 8.h),
        // _AttachmentItemCard(
        //   fileName: 'Cardiology_ECG_Strip.pdf',
        //   fileInfo: 'Lab & ECG · 2.1 MB',
        //   icon: Icons.monitor_heart_outlined,
        //   iconBgColor: const Color(0xFFE0F2FE),
        //   iconColor: const Color(0xFF0284C7),
        // ),
      ],
    );
  }
}

class _AttachmentItemCard extends StatelessWidget {
  final String fileName;
  final String fileInfo;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  const _AttachmentItemCard({
    required this.fileName,
    required this.fileInfo,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.fieldBorder.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavyText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  fileInfo,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.secondaryGrey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline_rounded,
              color: AppColors.red.withValues(alpha: 0.8),
              size: 20.sp,
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.all(4.r),
          ),
        ],
      ),
    );
  }
}
