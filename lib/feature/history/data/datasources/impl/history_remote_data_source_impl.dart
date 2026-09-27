import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_attachment_entity.dart';
import 'package:medivault/feature/add_visit/data/model/visit_model.dart';
import '../contract/history_remote_data_source.dart';

@Injectable(as: HistoryRemoteDataSource)
class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Connectivity _connectivity;

  HistoryRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Connectivity? connectivity,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _connectivity = connectivity ?? Connectivity();

  @override
  Future<Map<String, int>> getVisitCountsBySpecialty() async {
    await _checkConnectivity();
    final userId = _getUserId();

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .get();

    final Map<String, int> counts = {};
    for (final doc in querySnapshot.docs) {
      final specialtyId = doc.data()['specialtyId'] as String?;
      if (specialtyId != null && specialtyId.isNotEmpty) {
        counts[specialtyId] = (counts[specialtyId] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Future<List<VisitModel>> getVisitsBySpecialty(String specialtyId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .where('specialtyId', isEqualTo: specialtyId)
        .orderBy('visitDate', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => VisitModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<VisitModel> getVisitDetails(String visitId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .doc(visitId)
        .get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception('Visit record not found.');
    }

    return VisitModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
  }

  @override
  Future<void> updateVisit(VisitModel visit) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (visit.id == null || visit.id!.isEmpty) {
      throw Exception('Visit ID cannot be null or empty for update.');
    }

    final List<VisitAttachmentEntity> uploadedAttachments = [];

    for (final attachment in visit.attachments) {
      if (attachment.localPath != null &&
          attachment.localPath!.isNotEmpty &&
          (attachment.fileUrl == null || attachment.fileUrl!.isEmpty)) {
        final file = File(attachment.localPath!);
        if (await file.exists()) {
          final storagePath =
              'users/$userId/visits/${visit.id}/attachments/${attachment.fileName}';
          final storageRef = _storage.ref().child(storagePath);
          final uploadTask = await storageRef.putFile(file);
          final downloadUrl = await uploadTask.ref.getDownloadURL();

          uploadedAttachments.add(
            VisitAttachmentEntity(
              id: attachment.id,
              fileName: attachment.fileName,
              fileUrl: downloadUrl,
              fileType: attachment.fileType,
              fileSize: attachment.fileSize,
              localPath: attachment.localPath,
            ),
          );
        } else {
          uploadedAttachments.add(attachment);
        }
      } else {
        uploadedAttachments.add(attachment);
      }
    }

    final updatedModel = VisitModel(
      id: visit.id,
      specialtyId: visit.specialtyId,
      visitDate: visit.visitDate,
      doctorName: visit.doctorName,
      clinicHospital: visit.clinicHospital,
      symptoms: visit.symptoms,
      diagnosis: visit.diagnosis,
      advisoryNotes: visit.advisoryNotes,
      prescriptions: visit.prescriptions,
      createdAt: visit.createdAt ?? DateTime.now(),
      attachments: uploadedAttachments,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .doc(visit.id)
        .set(updatedModel.toFirestore(), SetOptions(merge: true));
  }

  String _getUserId() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      throw Exception('user_not_authenticated');
    }
    return userId;
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasConnection =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.ethernet);
    if (!hasConnection) {
      throw Exception('errors.no_internet_connection');
    }
  }
}
