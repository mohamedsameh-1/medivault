import 'package:dartz/dartz.dart';
import 'package:medivault/core/utils/failure.dart';
import '../entities/home_data_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, HomeDataEntity>> getHomeData();
}
