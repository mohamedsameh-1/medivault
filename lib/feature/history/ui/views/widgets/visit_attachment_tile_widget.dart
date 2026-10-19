import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';

class VisitAttachmentTileWidget extends StatelessWidget {
  final String name;
  final String type;
  final bool isImage;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const VisitAttachmentTileWidget({
    super.key,
    required this.name,
    required this.type,
    required this.isImage,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isImage ? const Color(0xFFEEF2FF) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: isImage ? AppColors.badgeGreenBg : AppColors.red,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              isImage ? Icons.image_outlined : Icons.picture_as_pdf_outlined,
              size: 20.r,
              color: isImage ? AppColors.primaryTeal : AppColors.white,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkNavyText,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  type,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryGrey,
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null) ...[
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
                size: 20.r,
              ),
              onPressed: onDelete,
            ),
          ] else if (onView != null) ...[
            SizedBox(width: 8.w),
            InkWell(
              onTap: onView,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isImage
                      ? Icons.remove_red_eye_outlined
                      : Icons.download_rounded,
                  size: 16.r,
                  color: AppColors.secondaryGrey,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
