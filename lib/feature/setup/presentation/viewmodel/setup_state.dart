part of 'setup_cubit.dart';

sealed class SetupState {}

class SetupInitial extends SetupState {}

class SetupLoading extends SetupState {}

class SetupSuccess extends SetupState {}

class SetupDataLoaded extends SetupState {
  final SetupModel setupModel;

  SetupDataLoaded(this.setupModel);
}

class SetupFailure extends SetupState {
  final String message;

  SetupFailure(this.message);
}
