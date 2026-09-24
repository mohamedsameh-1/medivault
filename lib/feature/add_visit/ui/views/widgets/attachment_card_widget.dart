import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import '../../../domain/entities/visit_attachment_entity.dart';

class AttachmentCardWidget extends StatelessWidget {
  final VisitAttachmentEntity attachment;
  final VoidCallback onDelete;

  const AttachmentCardWidget({
    super.key,
    required this.attachment,
    required this.onDelete,
  });

  // String _formatFileSize(int bytes) {
  //   if (bytes <= 0) return '0 B';
  //   if (bytes < 1024 * 1024) {
  //     final kb = (bytes / 1024).toStringAsFixed(1);
  //     return '$kb KB';
  //   }
  //   final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
  //   return '$mb MB';
  // }

  @override
  Widget build(BuildContext context) {
    final bool isPdf = attachment.fileType.toLowerCase() == 'pdf';
    final String categoryTag = isPdf ? 'Lab & ECG' : 'Rx/Recip';
    // final String formattedSize = _formatFileSize(attachment.fileSize);

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1.w),
      ),
      child: Row(
        children: [
          // Thumbnail / File Type Icon Box
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: isPdf ? const Color(0xFFDBEAFE) : AppColors.badgeGreenBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              isPdf
                  ? Icons.picture_as_pdf_outlined
                  : Icons.receipt_long_outlined,
              color: isPdf ? AppColors.strengthBlueText : AppColors.primaryTeal,
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),

          // File Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.fileName,
                  style: AppStyles.w600S14DarkNavy.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      isPdf ? Icons.analytics_outlined : Icons.receipt_outlined,
                      size: 13.r,
                      color: AppColors.primaryTeal,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      categoryTag,
                      style: AppStyles.w600S14PrimaryTeal.copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: AppStyles.w400S14Grey.copyWith(fontSize: 11.sp),
                    ),
                    // Text(
                    //   formattedSize,
                    //   style: AppStyles.w400S14Grey.copyWith(fontSize: 11.sp),
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Button
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.secondaryGrey,
              size: 20.r,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
