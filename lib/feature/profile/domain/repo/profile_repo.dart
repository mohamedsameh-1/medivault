import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfileData();
  Future<Either<Failure, void>> updateProfileData(ProfileEntity profile);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount();
}
