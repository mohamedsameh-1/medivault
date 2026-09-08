import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;

  LoginUseCase(this._authRepo);

  Future<Either<Failure, UserEntity>> invoke({
    required String email,
    required String password,
  }) {
    return _authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
