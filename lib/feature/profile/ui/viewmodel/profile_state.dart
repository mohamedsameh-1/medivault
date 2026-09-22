import 'package:medivault/core/utils/failure.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

// Fetch Profile States
class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileEntity profileEntity;
  ProfileSuccessState({required this.profileEntity});
}

class ProfileFailureState extends ProfileState {
  final Failure failure;
  ProfileFailureState({required this.failure});
}

// Logout States
class ProfileLogoutLoadingState extends ProfileState {}

class ProfileLogoutSuccessState extends ProfileState {}

class ProfileLogoutFailureState extends ProfileState {
  final Failure failure;
  ProfileLogoutFailureState({required this.failure});
}

// Delete Account States
class ProfileDeleteAccountLoadingState extends ProfileState {}

class ProfileDeleteAccountSuccessState extends ProfileState {}

class ProfileDeleteAccountFailureState extends ProfileState {
  final Failure failure;
  ProfileDeleteAccountFailureState({required this.failure});
}

// Update Profile States
class ProfileUpdateLoadingState extends ProfileState {}

class ProfileUpdateSuccessState extends ProfileState {}

class ProfileUpdateFailureState extends ProfileState {
  final Failure failure;
  ProfileUpdateFailureState({required this.failure});
}

