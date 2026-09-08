import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/user_entity.dart';
import '../repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);

  Future<Either<Failure, UserEntity>> invoke({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _authRepo.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
