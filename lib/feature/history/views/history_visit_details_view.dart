import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_attachment_entity.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/add_visit/ui/views/models/specialty_model.dart';
import 'package:medivault/feature/history/views/widgets/share_visit_button_widget.dart';
import 'package:medivault/feature/history/views/widgets/visit_attachment_tile_widget.dart';

class HistoryVisitDetailsView extends StatefulWidget {
  final SpecialtyModel specialty;
  final Map<String, dynamic> visitData;

  const HistoryVisitDetailsView({
    super.key,
    required this.specialty,
    required this.visitData,
  });

  @override
  State<HistoryVisitDetailsView> createState() =>
      _HistoryVisitDetailsViewState();
}

class _HistoryVisitDetailsViewState extends State<HistoryVisitDetailsView> {
  late Map<String, dynamic> _visitData;

  ///original data sent to the details view
  VisitEntity? _currentVisit;

  /// if updated from edit screen
  bool _wasUpdated = false;

  @override
  void initState() {
    super.initState();
    _visitData = Map<String, dynamic>.from(widget.visitData);
    if (_visitData['visit'] is VisitEntity) {
      _currentVisit = _visitData['visit'] as VisitEntity;
    }
  }

  void _handlePop() {
    Navigator.of(context).pop(_wasUpdated ? (_currentVisit ?? true) : null);
  }

  @override
  Widget build(BuildContext context) {
    final String date = _currentVisit != null
        ? DateFormat('MMM dd, yyyy').format(_currentVisit!.visitDate)
        : (_visitData['date'] ?? '');
    final String doctorName =
        _currentVisit?.doctorName ?? _visitData['doctorName'] ?? '';
    final String clinicName =
        _currentVisit?.clinicHospital ?? _visitData['clinicName'] ?? '';
    final String reason =
        _currentVisit?.symptoms ?? _visitData['reasonForVisit'] ?? '';
    final String diagnosis =
        _currentVisit?.diagnosis ?? _visitData['diagnosis'] ?? '';
    final String advisory =
        _currentVisit?.advisoryNotes ?? _visitData['advisoryNotes'] ?? '';
    final String prescriptions =
        _currentVisit?.prescriptions ?? _visitData['prescriptions'] ?? '';
    final List<dynamic> attachments =
        _currentVisit?.attachments ?? _visitData['attachments'] ?? [];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handlePop();
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        appBar: AppBar(
          backgroundColor: AppColors.screenBg,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.darkNavyText,
              size: 20.r,
            ),
            onPressed: _handlePop,
          ),
          title: Text(
            'visit_details'.tr(),
            style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 18.sp),
          ),
          actions: [
            // Edit Action Button in AppBar
            Padding(
              padding: EdgeInsets.only(
                right: context.locale.languageCode == 'en' ? 16.w : 0,
                left: context.locale.languageCode == 'ar' ? 16.w : 0,
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.editVisitView,
                      arguments: {
                        'specialty': widget.specialty,
                        'visitData': _currentVisit != null
                            ? {'visit': _currentVisit}
                            : _visitData,
                      },
                    );
                    if (result is VisitEntity) {
                      setState(() {
                        _currentVisit = result;
                        _visitData['visit'] = result;
                        _wasUpdated = true;
                      });
                    }
                  },
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
                          color: AppColors.bannerBg,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.edit.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bannerBg,
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
                // 1. Specialty Category Card
                _buildCategoryCard(),
                SizedBox(height: 20.h),

                // 2. Consultation Information Header
                Row(
                  children: [
                    Icon(
                      Icons.medical_information_outlined,
                      size: 20.r,
                      color: AppColors.primaryTeal,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'consultation_information'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkNavyText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Consultation Information Content Card
                Container(
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                        AppStrings.visitDate.tr().toUpperCase(),
                        date,
                      ),
                      _buildDivider(),
                      _buildInfoSection(
                        AppStrings.doctorName.tr().toUpperCase(),
                        doctorName,
                      ),
                      _buildDivider(),
                      _buildInfoSection(
                        AppStrings.clinicHospital.tr().toUpperCase(),
                        clinicName,
                      ),
                      _buildDivider(),
                      _buildInfoSection(
                        AppStrings.symptoms.tr().toUpperCase(),
                        reason,
                      ),
                      _buildDivider(),
                      _buildInfoSection(
                        AppStrings.doctorDiagnosis.tr().toUpperCase(),
                        diagnosis,
                      ),
                      if (advisory.isNotEmpty) ...[
                        _buildDivider(),
                        _buildInfoSection(
                          AppStrings.advisoryNotes.tr().toUpperCase(),
                          advisory,
                        ),
                      ],
                      if (prescriptions.isNotEmpty) ...[
                        _buildDivider(),
                        _buildInfoSection(
                          AppStrings.prescriptions.tr().toUpperCase(),
                          prescriptions,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // 3. Medical Attachments Section
                if (attachments.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        size: 20.r,
                        color: AppColors.primaryTeal,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'medical_attachments'.tr(),
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkNavyText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.fieldBorder,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.darkNavyText,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: List.generate(attachments.length, (index) {
                        final item = attachments[index];
                        String name = '';
                        String type = '';
                        bool isImage = true;

                        if (item is VisitAttachmentEntity) {
                          name = item.fileName;
                          isImage =
                              item.fileType.toLowerCase() == 'image' ||
                              name.endsWith('.jpg') ||
                              name.endsWith('.png') ||
                              name.endsWith('.jpeg');
                          type = item.fileSize != null
                              ? '${(item.fileSize! / 1024).toStringAsFixed(1)} KB • ${isImage ? "Image" : "PDF"}'
                              : (isImage ? 'Image Attachment' : 'PDF Document');
                        } else if (item is Map) {
                          name = item['name'] ?? '';
                          type = item['type'] ?? '';
                          isImage = item['isImage'] ?? true;
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == attachments.length - 1 ? 0 : 10.h,
                          ),
                          child: VisitAttachmentTileWidget(
                            name: name,
                            type: type,
                            isImage: isImage,
                            onView: () {},
                            onDelete: () {},
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                ///Share visit Details
                ShareVisitButtonWidget(
                  visitEntity: _currentVisit,
                  visitData: _visitData,
                  specialty: widget.specialty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.bannerBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                height: double.infinity,
                width: double.infinity,
                widget.specialty.iconPath,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.medical_services_outlined, size: 24.r),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specialty.title.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkNavyText,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.specialty.description.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.secondaryGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: AppColors.primaryTeal,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkNavyText,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(color: AppColors.primaryTeal, height: 1),
    );
  }
}
