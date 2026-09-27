// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/utils/app_colors.dart';
// import '../../../../core/utils/app_strings.dart';

// enum ShareOption { text, images }

// class ShareOptionsBottomSheetWidget extends StatelessWidget {
//   const ShareOptionsBottomSheetWidget({super.key});

//   static Future<ShareOption?> show(BuildContext context) {
//     return showModalBottomSheet<ShareOption>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => const ShareOptionsBottomSheetWidget(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x1A000000),
//             blurRadius: 16,
//             offset: Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Drag Handle
//             Center(
//               child: Container(
//                 width: 40.w,
//                 height: 4.h,
//                 margin: EdgeInsets.only(bottom: 16.h),
//                 decoration: BoxDecoration(
//                   color: AppColors.secondaryGrey.withValues(alpha: 0.3),
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//             ),

//             // Header Title
//             Text(
//               AppStrings.shareVisitOptions.tr(),
//               style: GoogleFonts.inter(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.darkNavyText,
//               ),
//             ),
//             SizedBox(height: 16.h),

//             // Option 1: Share as Text
//             _buildOptionTile(
//               context: context,
//               icon: Icons.article_outlined,
//               title: AppStrings.shareAsText.tr(),
//               subtitle: AppStrings.shareAsTextDesc.tr(),
//               onTap: () => Navigator.pop(context, ShareOption.text),
//             ),
//             SizedBox(height: 12.h),

//             // Option 2: Share Images
//             _buildOptionTile(
//               context: context,
//               icon: Icons.photo_library_outlined,
//               title: AppStrings.shareImages.tr(),
//               subtitle: AppStrings.shareImagesDesc.tr(),
//               onTap: () => Navigator.pop(context, ShareOption.images),
//             ),
//             SizedBox(height: 12.h),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16.r),
//         child: Container(
//           padding: EdgeInsets.all(14.r),
//           decoration: BoxDecoration(
//             color: AppColors.screenBg,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(color: AppColors.fieldBorder, width: 1),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 44.r,
//                 height: 44.r,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryTealLight,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: 22.r,
//                   color: AppColors.primaryTeal,
//                 ),
//               ),
//               SizedBox(width: 14.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: GoogleFonts.inter(
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.darkNavyText,
//                       ),
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       subtitle,
//                       style: GoogleFonts.inter(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w400,
//                         color: AppColors.secondaryGrey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 16.r,
//                 color: AppColors.iconGrey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
