import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../repo/history_repo.dart';

@injectable
class DeleteVisitImageUseCase {
  final HistoryRepo _historyRepo;

  DeleteVisitImageUseCase(this._historyRepo);

  Future<Either<Failure, Unit>> call({
    required String visitId,
    required String storagePath,
  }) {
    return _historyRepo.deleteVisitImage(
      visitId: visitId,
      storagePath: storagePath,
    );
  }
}

