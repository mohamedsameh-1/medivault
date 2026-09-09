import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medivault/core/di/di.dart';
import 'package:medivault/feature/setup/presentation/viewmodel/setup_cubit.dart';
import 'package:medivault/feature/setup/presentation/views/widgets/setup_body.dart';

class SetupView extends StatelessWidget {
  const SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<SetupCubit>(), child: SetupBody());
  }
}
