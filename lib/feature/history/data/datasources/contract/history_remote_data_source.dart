import 'package:medivault/feature/add_visit/data/model/visit_model.dart';

abstract class HistoryRemoteDataSource {
  /// Fetches visit counts for all specialties for the current user.
  Future<Map<String, int>> getVisitCountsBySpecialty();

  /// Fetches visits belonging to a given specialty, ordered newest first.
  Future<List<VisitModel>> getVisitsBySpecialty(String specialtyId);

  /// Fetches details for a specific visit document ID.
  Future<VisitModel> getVisitDetails(String visitId);

  /// Updates an existing visit record in Firestore.
  Future<void> updateVisit(VisitModel visit);
}
