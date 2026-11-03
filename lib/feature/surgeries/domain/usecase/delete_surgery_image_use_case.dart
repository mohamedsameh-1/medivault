import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../repo/surgeries_repo.dart';

@injectable
class DeleteSurgeryImageUseCase {
  final SurgeriesRepo _surgeriesRepo;

  DeleteSurgeryImageUseCase(this._surgeriesRepo);

  Future<Either<Failure, Unit>> call({
    required String surgeryId,
    required String storagePath,
  }) {
    return _surgeriesRepo.deleteSurgeryImage(
      surgeryId: surgeryId,
      storagePath: storagePath,
    );
  }
}

