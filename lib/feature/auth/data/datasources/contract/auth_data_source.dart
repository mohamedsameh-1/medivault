import 'package:dartz/dartz.dart';
import '../../../../../core/utils/failure.dart';
import '../../model/user_model.dart';

abstract class AuthDataSource {
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  });
}
