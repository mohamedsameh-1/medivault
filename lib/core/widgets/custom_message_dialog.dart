// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medivault/core/utils/app_colors.dart';
// import 'package:medivault/core/utils/app_styles.dart';

// enum MessageType { loading, success, error }

// class CustomMessageDialog extends StatelessWidget {
//   final String message;
//   final MessageType type;

//   const CustomMessageDialog({
//     super.key,
//     required this.message,
//     required this.type,
//   });

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color iconColor;

//     // تحديد الأيقونة واللون حسب الحالة
//     switch (type) {
//       case MessageType.loading:
//         icon = Icons.hourglass_empty_rounded;
//         iconColor = AppColors.green;
//         break;
//       case MessageType.success:
//         icon = Icons.check_circle_outline;
//         iconColor = AppColors.green;
//         break;
//       case MessageType.error:
//         icon = Icons.error_outline;
//         iconColor = AppColors.red;
//         break;
//     }

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//       backgroundColor: AppColors.white,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (type == MessageType.loading)
//               const CircularProgressIndicator(color: AppColors.green,)
//             else
//               Icon(icon, color: iconColor, size: 50.sp),
//             SizedBox(height: 20.h),
//             Text(
//               message,
//               style: AppStyles.w600S16PrimaryTeal,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';

enum MessageType { loading, success, error }

class CustomMessageDialog extends StatelessWidget {
  final String message;
  final MessageType type;

  const CustomMessageDialog({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor) = _getMessageStyle();

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 50.sp),
            SizedBox(height: 20.h),
            Text(
              message,
              style: AppStyles.w600S16PrimaryTeal,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color) _getMessageStyle() {
    switch (type) {
      case MessageType.loading:
        return (Icons.hourglass_empty_rounded, AppColors.green);

      case MessageType.success:
        return (Icons.check_circle_outline, AppColors.green);

      case MessageType.error:
        return (Icons.error_outline, AppColors.red);
    }
  }
}
