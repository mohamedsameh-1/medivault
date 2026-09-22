import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecase/delete_account_use_case.dart';
import '../../domain/usecase/get_profile_use_case.dart';
import '../../domain/usecase/logout_use_case.dart';
import '../../domain/usecase/update_profile_use_case.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._deleteAccountUseCase,
  ) : super(ProfileInitialState());

  Future<void> getProfileData() async {
    emit(ProfileLoadingState());
    final result = await _getProfileUseCase.invoke();
    result.fold(
      (failure) => emit(ProfileFailureState(failure: failure)),
      (profileEntity) => emit(ProfileSuccessState(profileEntity: profileEntity)),
    );
  }

  Future<void> updateProfileData(ProfileEntity profile) async {
    emit(ProfileUpdateLoadingState());
    final result = await _updateProfileUseCase.invoke(profile);
    result.fold(
      (failure) => emit(ProfileUpdateFailureState(failure: failure)),
      (_) async {
        emit(ProfileUpdateSuccessState());
        await getProfileData();
      },
    );
  }

  Future<void> logout() async {
    emit(ProfileLogoutLoadingState());
    final result = await _logoutUseCase.invoke();
    result.fold(
      (failure) => emit(ProfileLogoutFailureState(failure: failure)),
      (_) => emit(ProfileLogoutSuccessState()),
    );
  }

  Future<void> deleteAccount() async {
    emit(ProfileDeleteAccountLoadingState());
    final result = await _deleteAccountUseCase.invoke();
    result.fold(
      (failure) => emit(ProfileDeleteAccountFailureState(failure: failure)),
      (_) => emit(ProfileDeleteAccountSuccessState()),
    );
  }
}
