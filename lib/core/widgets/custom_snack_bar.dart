import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SnackBar customSnackBar({
  required String content,
  required Color backgroundColor,
  Duration? duration,
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: 30.h, left: 18.w, right: 18.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
    content: Text(content),
    backgroundColor: backgroundColor,
    duration: duration ?? const Duration(seconds: 2),
  );
}
