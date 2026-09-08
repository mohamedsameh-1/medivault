import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/auth_validators.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevate_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../viewmodel/register/register_cubit.dart';
import '../viewmodel/register/register_state.dart';
import 'widgets/disclaimer_checkbox.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isDisclaimerAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => getIt<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomMessageDialog(
                message: state.failure.failureMessage.tr(),
                type: MessageType.error,
              ),
            );
          } else if (state is RegisterSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.setupView);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.registerSubtitle.tr()),
                backgroundColor: AppColors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.screenBg,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.h),
                      Text(
                        AppStrings.createYourAccount.tr(),
                        style: AppStyles.w700S24DarkNavy,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.registerSubtitle.tr(),
                        style: AppStyles.w400S14Grey,
                      ),
                      SizedBox(height: 24.h),

                      // Form Container
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Full Name Field
                            CustomTextField(
                              label: AppStrings.fullName.tr(),
                              hintText: AppStrings.enterYourName.tr(),
                              controller: _fullNameController,
                              prefixIcon: const Icon(Icons.person_outline),
                              validator: (value) {
                                final validate = AuthValidators.validateName(
                                  value,
                                );
                                return validate?.tr();
                              },
                            ),
                            SizedBox(height: 18.h),

                            // Email Field
                            CustomTextField(
                              label: AppStrings.email.tr(),
                              hintText: AppStrings.enterYourEmail.tr(),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.mail_outline_rounded,
                              ),
                              validator: (value) {
                                final validate = AuthValidators.validateEmail(
                                  value,
                                );
                                return validate?.tr();
                              },
                            ),
                            SizedBox(height: 18.h),

                            // Password Field
                            CustomTextField(
                              label: AppStrings.password.tr(),
                              hintText: AppStrings.enterYourPassword.tr(),
                              controller: _passwordController,
                              obscureText: _isPasswordObscured,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                              validator: (value) {
                                final validate =
                                    AuthValidators.validatePassword(value);
                                return validate?.tr();
                              },
                            ),
                            SizedBox(height: 18.h),

                            // Confirm Password Field
                            CustomTextField(
                              label: AppStrings.confirmPassword.tr(),
                              hintText: AppStrings.repeatPassword.tr(),
                              controller: _confirmPasswordController,
                              obscureText: _isConfirmPasswordObscured,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordObscured =
                                        !_isConfirmPasswordObscured;
                                  });
                                },
                              ),
                              validator: (value) {
                                final validate =
                                    AuthValidators.validateConfirmPassword(
                                      value,
                                      _passwordController.text,
                                    );
                                return validate?.tr();
                              },
                            ),
                            SizedBox(height: 20.h),

                            // Disclaimer Checkbox Box
                            DisclaimerCheckbox(
                              value: _isDisclaimerAccepted,
                              onChanged: (val) {
                                setState(() {
                                  _isDisclaimerAccepted = val ?? false;
                                });
                              },
                            ),
                            SizedBox(height: 28.h),

                            // Create Account Button
                            state is RegisterLoadingState
                                ? const CircularProgressIndicator()
                                : CustomElevatedBtn(
                                    title: AppStrings.createAccount.tr(),
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        context.read<RegisterCubit>().register(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          fullName: _fullNameController.text
                                              .trim(),
                                        );
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Bottom Link: Already have an account? Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount.tr(),
                            style: AppStyles.w400S14Grey,
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.loginView,
                                );
                              }
                            },
                            child: Text(
                              AppStrings.login.tr(),
                              style: AppStyles.w600S14PrimaryTeal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
