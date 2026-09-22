import 'package:dartz/dartz.dart';
import 'package:medivault/core/utils/failure.dart';
import '../../model/profile_model.dart';

abstract class ProfileDataSource {
  Future<Either<Failure, ProfileModel>> getProfileData();
  Future<Either<Failure, void>> updateProfileData(ProfileModel profile);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount();
}
