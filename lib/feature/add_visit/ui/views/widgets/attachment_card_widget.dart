import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import '../../../domain/entities/visit_attachment_entity.dart';

class AttachmentCardWidget extends StatelessWidget {
  final VisitAttachmentEntity attachment;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const AttachmentCardWidget({
    super.key,
    required this.attachment,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final bool isPdf = attachment.fileType.toLowerCase() == 'pdf';
    // final String categoryTag = isPdf ? 'Lab & ECG' : 'Rx/Recip';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.fieldBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.iconGrey,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail / File Type Icon Box
            Container(
              width: 46.w,
              height: 46.h,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.photo_camera_back_outlined,
                color: AppColors.white,
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
                  Text(
                    AppStrings.preview.tr(),
                    style: AppStyles.w600S14PrimaryTeal,
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.red,
                // size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
