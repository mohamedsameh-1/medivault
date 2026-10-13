import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomGradientHeader(
          child: AppBrandHeader(subtitle: AppStrings.home.tr()),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Greeting placeholder
                  _buildGreeting(),

                  SizedBox(height: 24.h),

                  // Recent Surgeries section
                  _buildSectionHeader(),

                  SizedBox(height: 12.h),

                  _buildSurgeryCard(),
                  SizedBox(height: 12.h),
                  _buildSurgeryCard(),

                  SizedBox(height: 12.h),

                  // Recent Doctor Visits section
                  _buildSectionHeader(),

                  SizedBox(height: 12.h),

                  _buildVisitCard(),
                  SizedBox(height: 12.h),
                  _buildVisitCard(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBox(width: 150.w, height: 18.h),
        SizedBox(height: 10.h),
        _buildBox(width: 220.w, height: 14.h),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBox(width: 145.w, height: 18.h),
        _buildBox(width: 55.w, height: 16.h),
      ],
    );
  }

  Widget _buildSurgeryCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for surgery icon
          _buildBox(width: 44.w, height: 44.w, radius: 12.r),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBox(width: 150.w, height: 16.h),
                SizedBox(height: 10.h),
                _buildBox(width: 115.w, height: 12.h),
                SizedBox(height: 10.h),
                _buildBox(width: 90.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Placeholder for specialty icon
              _buildBox(width: 40.w, height: 40.w, radius: 10.r),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBox(width: 145.w, height: 15.h),
                    SizedBox(height: 8.h),
                    _buildBox(width: 105.w, height: 12.h),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          _buildBox(width: 180.w, height: 12.h),

          SizedBox(height: 10.h),

          _buildBox(width: 130.w, height: 12.h),
        ],
      ),
    );
  }

  Widget _buildBox({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
