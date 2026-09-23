import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'models/specialty_model.dart';
import 'widgets/specialty_card_widget.dart';

class SelectSpecialtyView extends StatefulWidget {
  const SelectSpecialtyView({super.key});

  @override
  State<SelectSpecialtyView> createState() => _SelectSpecialtyViewState();
}

class _SelectSpecialtyViewState extends State<SelectSpecialtyView> {
  // Cardiology is selected by default as shown in the reference design
  String _selectedSpecialtyId = 'cardiology';

  SpecialtyModel get _selectedSpecialty {
    return SpecialtyModel.defaultSpecialties.firstWhere(
      (element) => element.id == _selectedSpecialtyId,
      orElse: () => SpecialtyModel.defaultSpecialties.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.darkNavyText,
            size: 20.r,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'select_medical_specialty'.tr(),
          style: AppStyles.w600S16White.copyWith(
            color: AppColors.darkNavyText,
            fontSize: 16.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Step progress indicator bar
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'step_1_of_2'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 4.h,
                    backgroundColor: AppColors.fieldBorder,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  // Section Title
                  Text(
                    'select_medical_specialty'.tr(),
                    style: AppStyles.w700S24DarkNavy.copyWith(fontSize: 22.sp),
                  ),
                  SizedBox(height: 6.h),
                  // Section Description
                  Text(
                    'subtitle_of_select_specialty'.tr(),
                    style: AppStyles.w400S14Grey.copyWith(
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Specialty cards grid (2 columns)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 0.98,
                    ),
                    itemCount: SpecialtyModel.defaultSpecialties.length,
                    itemBuilder: (context, index) {
                      final specialty =
                          SpecialtyModel.defaultSpecialties[index];
                      return SpecialtyCardWidget(
                        specialty: specialty,
                        isSelected: specialty.id == _selectedSpecialtyId,
                        onTap: () {
                          setState(() {
                            _selectedSpecialtyId = specialty.id;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'selected_specialty'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryGrey,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryTeal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            _selectedSpecialty.title.tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  CustomElevatedBtn(
                    title: 'continue_to_visit_details'.tr(),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.visitDetailsView,
                        arguments: _selectedSpecialty,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
