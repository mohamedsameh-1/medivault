import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/core/utils/app_colors.dart';
import 'package:medivault/core/utils/app_styles.dart';
import 'package:medivault/core/utils/custom_snack_bar.dart';
import 'package:medivault/core/widgets/custom_elevate_btn.dart';
import 'package:medivault/core/widgets/custom_gradient_header.dart';
import 'package:medivault/feature/profile/domain/entities/profile_entity.dart';
import 'package:medivault/feature/profile/ui/viewmodel/profile_cubit.dart';
import 'package:medivault/feature/profile/ui/viewmodel/profile_state.dart';
import 'package:medivault/core/widgets/app_brand_header.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/date_of_birth_field.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/gender_selector.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/measurement_field.dart';

class EditProfileView extends StatefulWidget {
  final ProfileEntity? profileEntity;

  const EditProfileView({super.key, this.profileEntity});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _heightController;
  late TextEditingController _weightController;
  DateTime? _selectedDate;
  late String _selectedGender;
  String? _fullName;
  String? _uId;
  String? _email;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      final ProfileEntity? profile =
          widget.profileEntity ??
          (ModalRoute.of(context)?.settings.arguments as ProfileEntity?);

      if (profile != null) {
        _uId = profile.uId;
        _email = profile.email;
        _fullName = profile.fullName ?? 'User';
        _selectedDate = profile.dateOfBirth;
        _selectedGender = profile.gender ?? 'Male';
        if (profile.height != null) {
          _heightController.text = profile.height!.toStringAsFixed(0);
        }
        if (profile.weight != null) {
          _weightController.text = profile.weight!.toStringAsFixed(0);
        }
      } else {
        _selectedGender = 'Male';
      }
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? DateTime(2000, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: AppColors.white,
              onSurface: AppColors.darkNavyText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProfile = ProfileEntity(
        uId: _uId,
        fullName: _fullName,
        email: _email,
        dateOfBirth: _selectedDate,
        gender: _selectedGender,
        height: double.tryParse(_heightController.text.trim()),
        weight: double.tryParse(_weightController.text.trim()),
      );

      // Delegate the actual network call to the cubit.
      // Success/failure feedback is handled by the BlocListener below.
      context.read<ProfileCubit>().updateProfileData(updatedProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccessState) {
            // Pop with `true` so the parent knows a refresh is needed.
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: 'profile.profile_updated_successfully'.tr(),
                backgroundColor: AppColors.primaryTeal,
              ),
            );
          } else if (state is ProfileUpdateFailureState) {
            // Show the connection/server error message instead.
            ScaffoldMessenger.of(context).showSnackBar(
              customSnackBar(
                content: state.failure.failureMessage.tr(),
                backgroundColor: AppColors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            final formattedDate = _selectedDate != null
                ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                : 'setup.select_date'.tr();

            return BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (prev, curr) =>
                  curr is ProfileUpdateLoadingState ||
                  curr is ProfileUpdateSuccessState ||
                  curr is ProfileUpdateFailureState,
              builder: (context, state) {
                final isLoading = state is ProfileUpdateLoadingState;

                return Scaffold(
                  body: Column(
                    children: [
                      CustomGradientHeader(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40.h,
                              left: context.locale.languageCode == 'ar'
                                  ? null
                                  : 15.w,
                              right: context.locale.languageCode == 'ar'
                                  ? 15.w
                                  : null,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColors.bannerBg,
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                              ),
                            ),
                            AppBrandHeader(
                              subtitle: 'profile.personal_information'.tr(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(19.w),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name (Read-only)
                                Text(
                                  'profile.name'.tr(),
                                  style: AppStyles.w600S13DisclaimerBold,
                                ),
                                SizedBox(height: 5.h),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 14.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightTealBg.withValues(
                                      alpha: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppColors.bannerBg,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        size: 18.sp,
                                        color: AppColors.primaryTeal,
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          _fullName ?? '',
                                          style: AppStyles.w600S14DarkNavy
                                              .copyWith(
                                                color: AppColors.darkNavyText
                                                    .withValues(alpha: 0.7),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 22.h),

                                // Date of Birth
                                Text(
                                  'setup.date_of_birth'.tr(),
                                  style: AppStyles.w600S13DisclaimerBold,
                                ),
                                SizedBox(height: 5.h),
                                DateOfBirthField(
                                  date: formattedDate,
                                  onTap: _selectDateOfBirth,
                                ),

                                SizedBox(height: 22.h),

                                // Gender Identity
                                Text(
                                  'setup.gender_identity'.tr(),
                                  style: AppStyles.w600S13DisclaimerBold,
                                ),
                                SizedBox(height: 7.h),
                                GenderSelector(
                                  selectedGender: _selectedGender,
                                  onChanged: (gender) {
                                    setState(() {
                                      _selectedGender = gender;
                                    });
                                  },
                                ),

                                SizedBox(height: 22.h),

                                // Height & Weight
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: MeasurementField(
                                        label: 'setup.height'.tr(),
                                        controller: _heightController,
                                        unit: 'cm',
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          final val = double.tryParse(
                                            value.trim(),
                                          );
                                          if (val == null ||
                                              val < 30 ||
                                              val > 250) {
                                            return '30 - 250 cm';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: MeasurementField(
                                        label: 'setup.weight'.tr(),
                                        controller: _weightController,
                                        unit: 'kg',
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Required';
                                          }
                                          final val = double.tryParse(
                                            value.trim(),
                                          );
                                          if (val == null ||
                                              val < 2 ||
                                              val > 300) {
                                            return '2 - 300 kg';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 40.h),

                                CustomElevatedBtn(
                                  title: isLoading
                                      ? 'saving'.tr()
                                      : 'save_changes'.tr(),
                                  onPressed: isLoading
                                      ? () {}
                                      : () => _onSave(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
