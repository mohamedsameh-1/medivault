import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/auth_validators.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/custom_elevate_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../viewmodel/login/login_cubit.dart';
import '../viewmodel/login/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomMessageDialog(
                message: state.failure.failureMessage.tr(),
                type: MessageType.error,
              ),
            );
          } else if (state is LoginSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoutes.setupView);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.loginSubtitle.tr()),
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
                      SizedBox(height: 30.h),
                      // Top Logo Container
                      CircleAvatar(
                        radius: 60.r,
                        child: Image.asset(AppAssets.loginLogo4x),
                      ),
                      SizedBox(height: 24.h),
                      // Welcome Header
                      Text(
                        AppStrings.welcomeBack.tr(),
                        style: AppStyles.w700S24DarkNavy,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppStrings.loginSubtitle.tr(),
                        style: AppStyles.w400S14Grey,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      // Form Card Container
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
                            SizedBox(height: 20.h),

                            // Password Field with Forgot Password Link Header
                            CustomTextField(
                              labelWidget: Text(
                                AppStrings.password.tr(),
                                style: AppStyles.w600S14DarkNavy,
                              ),
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
                            SizedBox(height: 28.h),
                            //forget password
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle forgot password
                                },
                                child: Text(
                                  AppStrings.forgotPassword.tr(),
                                  style: AppStyles.w600S14PrimaryTeal,
                                ),
                              ),
                            ),
                            SizedBox(height: 28.h),
                            // Login Button
                            state is LoginLoadingState
                                ? const CircularProgressIndicator()
                                : CustomElevatedBtn(
                                    title: AppStrings.login.tr(),
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        context.read<LoginCubit>().login(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                        );
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Bottom Link: Don't have an account? Create Account >
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAccount.tr(),
                            style: AppStyles.w400S14Grey,
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.registerView,
                              );
                            },
                            child: Text(
                              AppStrings.createAccount.tr(),
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
