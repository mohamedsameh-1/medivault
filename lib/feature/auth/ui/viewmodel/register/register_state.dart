import 'package:medivault/core/utils/failure.dart';
import '../../../domain/entities/user_entity.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final UserEntity userEntity;
  RegisterSuccessState({required this.userEntity});
}

class RegisterFailureState extends RegisterState {
  final Failure failure;
  RegisterFailureState({required this.failure});
}
