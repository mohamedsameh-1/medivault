import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../repo/profile_repo.dart';

@injectable
class DeleteAccountUseCase {
  final ProfileRepo _profileRepo;

  DeleteAccountUseCase(this._profileRepo);

  Future<Either<Failure, void>> invoke() {
    return _profileRepo.deleteAccount();
  }
}
