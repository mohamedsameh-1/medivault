import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../repo/history_repo.dart';

@injectable
class DeleteVisitUseCase {
  final HistoryRepo _historyRepo;

  DeleteVisitUseCase(this._historyRepo);

  Future<Either<Failure, Unit>> call(String visitId) {
    return _historyRepo.deleteVisit(visitId);
  }
}
