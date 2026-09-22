import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../entities/profile_entity.dart';
import '../repo/profile_repo.dart';

@injectable
class GetProfileUseCase {
  final ProfileRepo _profileRepo;

  GetProfileUseCase(this._profileRepo);

  Future<Either<Failure, ProfileEntity>> invoke() {
    return _profileRepo.getProfileData();
  }
}
