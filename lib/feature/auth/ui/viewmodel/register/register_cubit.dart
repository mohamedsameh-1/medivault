import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/register_use_case.dart';
import 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(RegisterInitialState());

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(RegisterLoadingState());
    final result = await _registerUseCase.invoke(
      email: email,
      password: password,
      fullName: fullName,
    );
    result.fold(
      (failure) => emit(RegisterFailureState(failure: failure)),
      (userEntity) => emit(RegisterSuccessState(userEntity: userEntity)),
    );
  }
}
