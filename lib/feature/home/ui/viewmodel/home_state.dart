import 'package:medivault/core/utils/failure.dart';
import '../../domain/entities/home_data_entity.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final HomeDataEntity homeData;

  HomeSuccessState({required this.homeData});
}

class HomeFailureState extends HomeState {
  final Failure failure;

  HomeFailureState({required this.failure});
}
