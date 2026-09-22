import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/feature/profile/ui/viewmodel/profile_cubit.dart';
import 'package:medivault/feature/profile/view/widgets/profile_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>()..getProfileData(),
      child: const ProfileBody(),
    );
  }
}
