import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/services/surgery_direct_share_service.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/widgets/custom_snack_bar.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';

class ShareSurgeryButtonWidget extends StatefulWidget {
  final SurgeryEntity surgeryEntity;

  const ShareSurgeryButtonWidget({super.key, required this.surgeryEntity});

  @override
  State<ShareSurgeryButtonWidget> createState() =>
      _ShareSurgeryButtonWidgetState();
}

class _ShareSurgeryButtonWidgetState extends State<ShareSurgeryButtonWidget> {
  bool _isLoading = false;

  Future<void> _handleShare() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final shareService = getIt<SurgeryDirectShareService>();

      await shareService.shareSurgeryAsText(surgery: widget.surgeryEntity);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: AppStrings.failedToShareVisit.tr(),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleShare,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          disabledBackgroundColor: AppColors.primaryTeal.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.bannerBg,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    AppStrings.loading.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bannerBg,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share_sharp,
                    size: 20.r,
                    color: AppColors.bannerBg,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.shareSurgeryReport.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bannerBg,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
