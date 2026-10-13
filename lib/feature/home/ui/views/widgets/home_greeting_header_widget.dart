import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_strings.dart';
import 'package:medivault/core/utils/app_styles.dart';

class HomeGreetingHeaderWidget extends StatelessWidget {
  final String userName;

  const HomeGreetingHeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TyperAnimatedText(
              userName.isNotEmpty
                  ? AppStrings.homeGreeting.tr(args: [userName])
                  : AppStrings.homeGreetingGeneric.tr(),
              textStyle: AppStyles.w700S24DarkNavy,
              speed: const Duration(milliseconds: 150),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(AppStrings.homeSubtitle.tr(), style: AppStyles.w400S14Grey),
      ],
    );
  }
}
