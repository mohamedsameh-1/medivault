import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../entities/profile_entity.dart';
import '../repo/profile_repo.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepo _profileRepo;

  UpdateProfileUseCase(this._profileRepo);

  Future<Either<Failure, void>> invoke(ProfileEntity profile) {
    return _profileRepo.updateProfileData(profile);
  }
}
