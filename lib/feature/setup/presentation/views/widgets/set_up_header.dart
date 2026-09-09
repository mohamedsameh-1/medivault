import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_assets.dart';
import 'package:medivault/core/utils/app_styles.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppAssets.loginLogo4x, height: 100.h),
        SizedBox(height: 16.h),
        Text('setup.title'.tr(), style: AppStyles.w700S24DarkNavy),
        SizedBox(height: 4.h),
        Center(
          child: Text('setup.subtitle'.tr(), style: AppStyles.w400S14Grey),
        ),
      ],
    );
  }
}
