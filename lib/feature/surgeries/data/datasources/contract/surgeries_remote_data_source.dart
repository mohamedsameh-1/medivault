import '../../model/surgery_model.dart';

abstract class SurgeriesRemoteDataSource {
  Future<List<SurgeryModel>> getSurgeries();
  Future<SurgeryModel> getSurgeryDetails(String surgeryId);
  Future<void> addSurgery(SurgeryModel surgery);
  Future<void> updateSurgery(SurgeryModel surgery);
  Future<void> deleteSurgery(String surgeryId);
}
