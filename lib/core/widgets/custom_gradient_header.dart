import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_colors.dart';

class CustomGradientHeader extends StatelessWidget {
  final Widget? child;
  const CustomGradientHeader({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        // color: AppColors.primaryTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26.r),
          bottomRight: Radius.circular(26.r),
        ),
        gradient: LinearGradient(
          colors: [AppColors.primaryTeal, AppColors.greenLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}
