import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';

class ImagePreviewDialog extends StatelessWidget {
  final String? imageUrl;
  final String? localPath;
  final String? title;

  const ImagePreviewDialog({
    super.key,
    this.imageUrl,
    this.localPath,
    this.title,
  });

  /// Displays the preview dialog with a smooth fade/scale transition.
  static Future<void> show({
    required BuildContext context,
    String? imageUrl,
    String? localPath,
    String? title,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => ImagePreviewDialog(
        imageUrl: imageUrl,
        localPath: localPath,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Interactive zoomable image
          Center(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              child: _buildImage(),
            ),
          ),

          // Top Header Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x99000000), Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    // Close button
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: 26.r,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 8.w),
                    // Title
                    Expanded(
                      child: Text(
                        title ?? AppStrings.imagePreview.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (localPath != null && localPath!.isNotEmpty) {
      File file;
      if (localPath!.startsWith('file://')) {
        try {
          file = File(Uri.parse(localPath!).toFilePath());
        } catch (_) {
          file = File(localPath!.replaceFirst('file://', ''));
        }
      } else {
        file = File(localPath!);
      }

      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.contain,
          cacheWidth: 1920,
          cacheHeight: 1920,
          errorBuilder: (context, error, stackTrace) {
            if (imageUrl != null && imageUrl!.isNotEmpty) {
              return _buildNetworkImage();
            }
            return _buildErrorWidget();
          },
        );
      }
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildNetworkImage();
    }

    return _buildErrorWidget();
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: 36.r,
            height: 36.r,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: AppColors.primaryTeal,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 48.r,
            color: AppColors.secondaryGrey,
          ),
          SizedBox(height: 12.h),
          Text(
            AppStrings.imageUploadFailed.tr(),
            style: GoogleFonts.inter(fontSize: 14.sp, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
