import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';

class VisitAttachmentTileWidget extends StatelessWidget {
  final String name;
  final String type;
  // final bool isImage;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const VisitAttachmentTileWidget({
    super.key,
    required this.name,
    required this.type,
    // required this.isImage,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryGrey.withOpacity(0.3),
            blurRadius: 4.r,
            offset: Offset(0, 2.r),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.image_outlined,
              size: 20.r,
              color: AppColors.white,
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
          // if (onView != null) ...[
          InkWell(
            onTap: onView,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: const BoxDecoration(
                color: AppColors.primaryTeal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove_red_eye_outlined,
                size: 16.r,
                color: AppColors.white,
              ),
            ),
          ),
          // ],
          if (onDelete != null) ...[
            SizedBox(width: 6.w),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
                size: 20.r,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}
