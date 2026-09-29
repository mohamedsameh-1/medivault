import '../../../../core/utils/failure.dart';
import '../../domain/entities/surgery_entity.dart';

abstract class SurgeriesState {}

/// Initial State
class SurgeriesInitialState extends SurgeriesState {}

/// Get/List Surgeries States
class GetSurgeriesLoadingState extends SurgeriesState {}

class GetSurgeriesSuccessState extends SurgeriesState {
  final List<SurgeryEntity> surgeries;
  GetSurgeriesSuccessState({required this.surgeries});
}

class GetSurgeriesEmptyState extends SurgeriesState {}

class GetSurgeriesFailureState extends SurgeriesState {
  final Failure failure;
  GetSurgeriesFailureState({required this.failure});
}

/// Add Surgery States
class AddSurgeryInitialState extends SurgeriesState {}

class AddSurgeryLoadingState extends SurgeriesState {}

class AddSurgerySuccessState extends SurgeriesState {}

class AddSurgeryFailureState extends SurgeriesState {
  final Failure failure;
  AddSurgeryFailureState({required this.failure});
}

/// Edit Surgery States
class EditSurgeryLoadingState extends SurgeriesState {}

class EditSurgerySuccessState extends SurgeriesState {
  final SurgeryEntity updatedSurgery;
  EditSurgerySuccessState({required this.updatedSurgery});
}

class EditSurgeryFailureState extends SurgeriesState {
  final Failure failure;
  EditSurgeryFailureState({required this.failure});
}

/// Delete Surgery States
class DeleteSurgeryLoadingState extends SurgeriesState {}

class DeleteSurgerySuccessState extends SurgeriesState {
  final String deletedId;
  DeleteSurgerySuccessState({required this.deletedId});
}

class DeleteSurgeryFailureState extends SurgeriesState {
  final Failure failure;
  DeleteSurgeryFailureState({required this.failure});
}
