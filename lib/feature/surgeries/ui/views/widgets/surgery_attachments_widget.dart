import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import '../../../domain/entities/surgery_attachment_entity.dart';

class SurgeryAttachmentsWidget extends StatelessWidget {
  final List<SurgeryAttachmentEntity> attachments;
  final bool isLoading;
  final VoidCallback onSelectImage;
  final ValueChanged<int> onRemove;
  final ValueChanged<SurgeryAttachmentEntity>? onPreview;

  const SurgeryAttachmentsWidget({
    super.key,
    required this.attachments,
    this.isLoading = false,
    required this.onSelectImage,
    required this.onRemove,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              color: AppColors.primaryTeal,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            Text(
              AppStrings.medicalAttachments.tr(),
              style: AppStyles.w700S24DarkNavy.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Action Button: Select Image
        Center(
          child: SizedBox(
            width: 200.w,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onSelectImage,
              icon: Icon(
                Icons.attachment_outlined,
                size: 20.r,
                color: AppColors.white,
              ),
              label: Text(
                AppStrings.selectImage.tr(),
                style: AppStyles.w600S14PrimaryTeal.copyWith(
                  color: AppColors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: AppColors.fieldBorder),
                ),
              ),
            ),
          ),
        ),

        // Selected Attachments List
        if (attachments.isNotEmpty) ...[
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attachments.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final item = attachments[index];

              return InkWell(
                onTap: onPreview != null ? () => onPreview!(item) : null,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.fieldBorder),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.iconGrey,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Thumbnail / Image Icon Box
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
                              item.fileName,
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
                        onPressed: isLoading ? null : () => onRemove(index),
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
