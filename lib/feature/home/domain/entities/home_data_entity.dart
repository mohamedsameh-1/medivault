import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';

class HomeDataEntity {
  final String userName;
  final List<SurgeryEntity> recentSurgeries;
  final int totalSurgeriesCount;
  final List<VisitEntity> recentVisits;
  final int totalVisitsCount;

  const HomeDataEntity({
    required this.userName,
    required this.recentSurgeries,
    required this.totalSurgeriesCount,
    required this.recentVisits,
    required this.totalVisitsCount,
  });
}
