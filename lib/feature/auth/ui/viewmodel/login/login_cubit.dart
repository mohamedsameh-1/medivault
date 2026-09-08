import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecase/login_use_case.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitialState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    final result = await _loginUseCase.invoke(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(LoginFailureState(failure: failure)),
      (userEntity) => emit(LoginSuccessState(userEntity: userEntity)),
    );
  }
}
