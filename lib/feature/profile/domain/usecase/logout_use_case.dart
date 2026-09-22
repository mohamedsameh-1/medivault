import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../repo/profile_repo.dart';

@injectable
class LogoutUseCase {
  final ProfileRepo _profileRepo;

  LogoutUseCase(this._profileRepo);

  Future<Either<Failure, void>> invoke() {
    return _profileRepo.logout();
  }
}
