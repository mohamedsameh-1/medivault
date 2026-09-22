import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../datasources/contract/profile_data_source.dart';
import '../model/profile_model.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileDataSource _profileDataSource;

  ProfileRepoImpl(this._profileDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfileData() async {
    final result = await _profileDataSource.getProfileData();
    return result.fold(
      (failure) => Left(failure),
      (profileModel) => Right(profileModel),
    );
  }

  @override
  Future<Either<Failure, void>> updateProfileData(ProfileEntity profile) async {
    final profileModel = ProfileModel(
      uId: profile.uId,
      fullName: profile.fullName,
      email: profile.email,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      height: profile.height,
      weight: profile.weight,
    );
    return _profileDataSource.updateProfileData(profileModel);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return _profileDataSource.logout();
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return _profileDataSource.deleteAccount();
  }
}
