import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medivault/core/utils/app_routes.dart';
import 'package:medivault/core/widgets/custom_message_dialog.dart';
import 'package:medivault/feature/setup/data/model/setup_model.dart';
import 'package:medivault/feature/setup/presentation/viewmodel/setup_cubit.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/basic_information_card.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/continue_field.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/set_up_header.dart';
import '../../../../../core/utils/app_colors.dart';

class SetupBody extends StatefulWidget {
  const SetupBody({super.key});

  @override
  State<SetupBody> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupBody> {
  DateTime? _dateOfBirth;

  String _selectedGender = 'male';
  // String _selectedBloodType = 'A+';

  final TextEditingController _heightController = TextEditingController(
    text: '170',
  );

  final TextEditingController _weightController = TextEditingController(
    text: '62',
  );

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _dateOfBirth = pickedDate;
      });
    }
  }

  String _formattedDate() {
    if (_dateOfBirth == null) {
      return 'setup.select_date'.tr();
    }

    return DateFormat.yMd(context.locale.languageCode).format(_dateOfBirth!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SetupHeader(),

              SizedBox(height: 20.h),

              BasicInformationCard(
                formattedDate: _formattedDate(),
                onDateTap: _selectDateOfBirth,
                selectedGender: _selectedGender,
                onGenderChanged: (gender) {
                  setState(() {
                    _selectedGender = gender;
                  });
                },
                // selectedBloodType: _selectedBloodType,
                // onBloodTypeChanged: (bloodType) {
                //   setState(() {
                //     _selectedBloodType = bloodType;
                //   });
                // },
                heightController: _heightController,
                weightController: _weightController,
              ),

              SizedBox(height: 22.h),

              BlocListener<SetupCubit, SetupState>(
                listener: (context, state) {
                  if (state is SetupLoading) {
                    showDialog(
                      context: context,
                      builder: (context) => CustomMessageDialog(
                        message: 'Loading...',
                        type: MessageType.loading,
                      ),
                    );
                  }
                  if (state is SetupSuccess) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.homeView);
                  }

                  if (state is SetupFailure) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => CustomMessageDialog(
                        message: state.message,
                        type: MessageType.error,
                      ),
                    );
                  }
                },
                child: ContinueButton(
                  onPressed: () {
                    final setupModel = SetupModel(
                      dateOfBirth: _dateOfBirth,
                      gender: _selectedGender,
                      height: double.tryParse(_heightController.text),
                      weight: double.tryParse(_weightController.text),
                    );

                    context.read<SetupCubit>().saveSetupData(
                      setupModel: setupModel,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
