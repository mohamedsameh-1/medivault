import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 6.h),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.darkNavyText,
              letterSpacing: 0.3,
            ),
          ),
        ),

        ...children,
      ],
    );
  }
}
