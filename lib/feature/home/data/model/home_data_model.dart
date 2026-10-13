import 'package:medivault/feature/add_visit/domain/entities/visit_entity.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_entity.dart';
import '../../domain/entities/home_data_entity.dart';

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required super.userName,
    required super.recentSurgeries,
    required super.totalSurgeriesCount,
    required super.recentVisits,
    required super.totalVisitsCount,
  });

  factory HomeDataModel.fromValues({
    required String userName,
    required List<SurgeryEntity> recentSurgeries,
    required int totalSurgeriesCount,
    required List<VisitEntity> recentVisits,
    required int totalVisitsCount,
  }) {
    return HomeDataModel(
      userName: userName,
      recentSurgeries: recentSurgeries,
      totalSurgeriesCount: totalSurgeriesCount,
      recentVisits: recentVisits,
      totalVisitsCount: totalVisitsCount,
    );
  }
}
