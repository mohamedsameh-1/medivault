import 'package:medivault/core/utils/failure.dart';
import '../../../domain/entities/user_entity.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final UserEntity userEntity;
  LoginSuccessState({required this.userEntity});
}

class LoginFailureState extends LoginState {
  final Failure failure;
  LoginFailureState({required this.failure});
}
