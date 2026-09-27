import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/services/visit_direct_share_service.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';

class ShareVisitButtonWidget extends StatefulWidget {
  final VisitEntity? visitEntity;
  final Map<String, dynamic>? visitData;
  final SpecialtyModel specialty;

  const ShareVisitButtonWidget({
    super.key,
    this.visitEntity,
    this.visitData,
    required this.specialty,
  });

  @override
  State<ShareVisitButtonWidget> createState() => _ShareVisitButtonWidgetState();
}

class _ShareVisitButtonWidgetState extends State<ShareVisitButtonWidget> {
  bool _isLoading = false;
  VisitEntity _buildVisitEntity() {
    if (widget.visitEntity != null) {
      return widget.visitEntity!;
    }

    final data = widget.visitData ?? {};

    DateTime visitDate = DateTime.now();

    if (data['date'] is String) {
      try {
        visitDate = DateFormat('MMM dd, yyyy').parse(data['date']);
      } catch (_) {}
    }

    return VisitEntity(
      id: data['id'],
      specialtyId: widget.specialty.id,
      visitDate: visitDate,
      doctorName: data['doctorName'] ?? '',
      clinicHospital: data['clinicName'] ?? '',
      symptoms: data['reasonForVisit'] ?? '',
      diagnosis: data['diagnosis'] ?? '',
      advisoryNotes: data['advisoryNotes'],
      prescriptions: data['prescriptions'],
    );
  }

  Future<void> _handleShare() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final visit = _buildVisitEntity();
      final specialtyTitle = widget.specialty.title.tr();

      final shareService = getIt<VisitDirectShareService>();
      await shareService.shareVisitAsText(
        visit: visit,
        specialtyTitle: specialtyTitle,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.failedToShareVisit.tr(),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
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
                    AppStrings.shareVisitReport.tr(),
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
