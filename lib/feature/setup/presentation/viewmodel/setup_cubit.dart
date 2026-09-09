import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/setup/data/model/setup_model.dart';
import 'package:medivault/feature/setup/data/repo/setup_repository.dart';

part 'setup_state.dart';

@injectable
class SetupCubit extends Cubit<SetupState> {
  final SetupRepository _repository;
  final FirebaseAuth _firebaseAuth;

  SetupCubit(this._repository, this._firebaseAuth) : super(SetupInitial());

  Future<void> saveSetupData({required SetupModel setupModel}) async {
    emit(SetupLoading());

    try {
      final userId = _firebaseAuth.currentUser?.uid;

      if (userId == null) {
        emit(SetupFailure('User is not authenticated'));
        return;
      }

      await _repository.saveSetupData(userId: userId, setupModel: setupModel);

      emit(SetupSuccess());
    } catch (e) {
      emit(SetupFailure(e.toString()));
    }
  }

  Future<void> getSetupData() async {
    emit(SetupLoading());

    try {
      final userId = _firebaseAuth.currentUser?.uid;

      if (userId == null) {
        emit(SetupFailure('User is not authenticated'));
        return;
      }

      final setupModel = await _repository.getSetupData(userId: userId);

      emit(SetupDataLoaded(setupModel));
    } catch (e) {
      emit(SetupFailure(e.toString()));
    }
  }
}
