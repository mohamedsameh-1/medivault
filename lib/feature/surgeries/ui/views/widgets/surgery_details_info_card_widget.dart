import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/medical_special_list.dart';

class SurgeryDetailsInfoCardWidget extends StatelessWidget {
  final String date;
  final String medicalSpecialty;
  final String surgeryName;
  final String surgeonName;
  final String hospitalName;
  final String diagnosis;
  // final String anesthesiaType;
  final String notes;

  const SurgeryDetailsInfoCardWidget({
    super.key,
    required this.date,
    required this.surgeryName,
    required this.surgeonName,
    required this.hospitalName,
    required this.diagnosis,
    // required this.anesthesiaType,
    required this.notes,
    required this.medicalSpecialty,
  });

  Widget _buildInfoSection(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTeal,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 4.h),
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
      child: Divider(height: 1, thickness: 1, color: AppColors.secondaryGrey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.checkboxBorder,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(AppStrings.surgeryDate.tr().toUpperCase(), date),

          if (medicalSpecialty.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(
              AppStrings.medicalSpecialty.tr().toUpperCase(),
              MedicalSpecialties.getSpecialtyTitle(medicalSpecialty),
            ),
          ],
          if (surgeryName.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(
              AppStrings.surgeryName.tr().toUpperCase(),
              surgeryName,
            ),
          ],
          if (surgeonName.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(
              AppStrings.surgeonName.tr().toUpperCase(),
              surgeonName,
            ),
          ],
          if (hospitalName.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(
              AppStrings.hospitalSurgicalCenter.tr().toUpperCase(),
              hospitalName,
            ),
          ],
          if (diagnosis.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(
              AppStrings.diagnosisReasonForProcedure.tr().toUpperCase(),
              diagnosis,
            ),
          ],
          if (notes.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoSection(AppStrings.notes.tr().toUpperCase(), notes),
          ],
        ],
      ),
    );
  }
}
