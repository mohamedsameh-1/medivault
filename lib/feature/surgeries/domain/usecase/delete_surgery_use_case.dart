import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/failure.dart';
import '../repo/surgeries_repo.dart';

@injectable
class DeleteSurgeryUseCase {
  final SurgeriesRepo _repository;

  DeleteSurgeryUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String surgeryId) {
    return _repository.deleteSurgery(surgeryId);
  }
}
