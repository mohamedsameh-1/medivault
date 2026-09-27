import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import '../repo/history_repo.dart';

@injectable
class GetVisitCountsUseCase {
  final HistoryRepo _historyRepo;

  GetVisitCountsUseCase(this._historyRepo);

  Future<Either<Failure, Map<String, int>>> call() {
    return _historyRepo.getVisitCountsBySpecialty();
  }
}
