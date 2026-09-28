import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import 'widgets/surgery_attachments_widget.dart';
import 'widgets/surgery_details_info_card_widget.dart';

class SurgeryDetailsView extends StatefulWidget {
  final SurgeryEntity? surgery;
  final Map<String, dynamic>? surgeryData;

  const SurgeryDetailsView({super.key, this.surgery, this.surgeryData});

  @override
  State<SurgeryDetailsView> createState() => _SurgeryDetailsViewState();
}

class _SurgeryDetailsViewState extends State<SurgeryDetailsView> {
  SurgeryEntity? _currentSurgery;
  Map<String, dynamic> _dataMap = {};

  @override
  void initState() {
    super.initState();
    _currentSurgery = widget.surgery;
    _dataMap = widget.surgeryData ?? {};
  }

  void _navigateToEdit() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.editSurgeryView,
      arguments: {'surgery': _currentSurgery, 'surgeryData': _dataMap},
    );
    if (result is SurgeryEntity) {
      setState(() {
        _currentSurgery = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback preview data if null
    final String surgeryName =
        _currentSurgery?.surgeryName ??
        _dataMap['surgeryName'] ??
        'ACL Reconstruction';

    final String dateStr = _currentSurgery != null
        ? DateFormat('MMM dd, yyyy').format(_currentSurgery!.surgeryDate)
        : (_dataMap['date'] ?? 'Sep 12, 2026');

    final String specialtyStr =
        _currentSurgery?.specialty ?? _dataMap['specialty'] ?? 'Orthopedics';

    final String doctorName =
        _currentSurgery?.doctorName ??
        _dataMap['doctorName'] ??
        'Dr. Ahmed Mohamed';

    final String hospitalName =
        _currentSurgery?.hospitalName ??
        _dataMap['hospitalName'] ??
        'ABC Hospital';

    final String diagnosis =
        _currentSurgery?.diagnosis ??
        _dataMap['diagnosis'] ??
        'Torn Anterior Cruciate Ligament';

    final String anesthesia =
        _currentSurgery?.anesthesiaType ??
        _dataMap['anesthesiaType'] ??
        'General Anesthesia';

    final String notes =
        _currentSurgery?.notes ??
        _dataMap['notes'] ??
        'Patient requires post-op physical therapy for 6 weeks.';

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.screenBg,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.darkNavyText,
            size: 20.r,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppStrings.surgeryDetails.tr(),
          style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
        ),
        actions: [
          // Edit Button in AppBar (Matching HistoryVisitDetailsView)
          Padding(
            padding: EdgeInsets.only(
              right: context.locale.languageCode == 'en' ? 16.w : 0,
              left: context.locale.languageCode == 'ar' ? 16.w : 0,
            ),
            child: Center(
              child: InkWell(
                onTap: _navigateToEdit,
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14.r,
                        color: AppColors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.edit.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Section Title: Surgery Information
              Row(
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 20.r,
                    color: AppColors.primaryTeal,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.surgeryInformation.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavyText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // 2. Information Details Card
              SurgeryDetailsInfoCardWidget(
                date: dateStr,
                medicalSpecialty: specialtyStr,
                surgeryName: surgeryName,
                surgeonName: doctorName,
                hospitalName: hospitalName,
                diagnosis: diagnosis,
                anesthesiaType: anesthesia,
                notes: notes,
              ),
              SizedBox(height: 20.h),

              // 3. Attachments Section Container
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.bannerBg, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.checkboxBorder,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const SurgeryAttachmentsWidget(),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
