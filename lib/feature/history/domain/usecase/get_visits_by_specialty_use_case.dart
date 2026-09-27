import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/utils/failure.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import '../repo/history_repo.dart';

@injectable
class GetVisitsBySpecialtyUseCase {
  final HistoryRepo _historyRepo;

  GetVisitsBySpecialtyUseCase(this._historyRepo);

  Future<Either<Failure, List<VisitEntity>>> call(String specialtyId) {
    return _historyRepo.getVisitsBySpecialty(specialtyId);
  }
}
