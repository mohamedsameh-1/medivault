import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';

enum MediaSourceType { camera, gallery, file }

class MediaSourceBottomSheet extends StatelessWidget {
  final bool showFileOption;

  const MediaSourceBottomSheet({super.key, this.showFileOption = true});

  static Future<MediaSourceType?> show(
    BuildContext context, {
    bool showFileOption = true,
  }) {
    return showModalBottomSheet<MediaSourceType>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          MediaSourceBottomSheet(showFileOption: showFileOption),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: AppColors.bannerBg,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.secondaryGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Header Title
            Text(
              AppStrings.selectImage.tr(),
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.darkNavyText,
              ),
            ),
            SizedBox(height: 16.h),

            // Option 1: Camera
            _buildOptionTile(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: AppStrings.camera.tr(),
              onTap: () => Navigator.pop(context, MediaSourceType.camera),
            ),
            SizedBox(height: 10.h),

            // Option 2: Gallery
            _buildOptionTile(
              context: context,
              icon: Icons.photo_library_outlined,
              title: AppStrings.gallery.tr(),
              onTap: () => Navigator.pop(context, MediaSourceType.gallery),
            ),

            // if (showFileOption) ...[
            //   SizedBox(height: 10.h),
            //   // Option 3: Document/Files
            //   _buildOptionTile(
            //     context: context,
            //     icon: Icons.insert_drive_file_outlined,
            //     title: AppStrings.chooseFile.tr(),
            //     onTap: () => Navigator.pop(context, MediaSourceType.file),
            //   ),
            // ],
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldBorder, width: 2.w),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 20.r, color: AppColors.white),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkNavyText,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.r,
              color: AppColors.secondaryGrey,
            ),
          ],
        ),
      ),
    );
  }
}
