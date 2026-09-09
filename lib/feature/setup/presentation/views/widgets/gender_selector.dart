import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'selection_button.dart';

class GenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectionButton(
            title: 'setup.male'.tr(),
            isSelected: selectedGender == 'male',
            onTap: () => onChanged('male'),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: SelectionButton(
            title: 'setup.female'.tr(),
            isSelected: selectedGender == 'female',
            onTap: () => onChanged('female'),
          ),
        ),
      ],
    );
  }
}
