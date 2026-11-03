import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/config/supabase_config.dart';
import 'package:medivault/core/services/supabase_storage_service.dart';
import 'package:medivault/feature/add_visit/domain/entities/visit_attachment_entity.dart';
import 'package:medivault/feature/add_visit/data/model/visit_model.dart';
import '../contract/history_remote_data_source.dart';

@Injectable(as: HistoryRemoteDataSource)
class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SupabaseStorageService _storageService;
  final Connectivity _connectivity;

  HistoryRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    required SupabaseStorageService storageService,
    Connectivity? connectivity,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storageService = storageService,
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

    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('visits')
          .where('specialtyId', isEqualTo: specialtyId)
          .orderBy('visitDate', descending: true)
          .get(const GetOptions(source: Source.server));
    } catch (_) {
      querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('visits')
          .where('specialtyId', isEqualTo: specialtyId)
          .orderBy('visitDate', descending: true)
          .get();
    }

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
    final List<String> updatedImagePaths = List.from(visit.imagePaths);

    for (final attachment in visit.attachments) {
      if (attachment.localPath != null &&
          attachment.localPath!.isNotEmpty &&
          (attachment.fileUrl == null || attachment.fileUrl!.isEmpty)) {
        final file = File(attachment.localPath!);
        if (await file.exists()) {
          final safeName = attachment.fileName.replaceAll(
            RegExp(r'[^a-zA-Z0-9._-]'),
            '_',
          );
          final uniqueFileName =
              '${DateTime.now().millisecondsSinceEpoch}_$safeName';
          final storagePath = '$userId/${visit.id}/$uniqueFileName';

          await _storageService.uploadImage(
            bucket: SupabaseConfig.visitImagesBucket,
            path: storagePath,
            file: file,
          );

          if (attachment.fileType.toLowerCase() == 'image' &&
              !updatedImagePaths.contains(storagePath)) {
            updatedImagePaths.add(storagePath);
          }

          uploadedAttachments.add(
            VisitAttachmentEntity(
              id: attachment.id,
              fileName: attachment.fileName,
              fileUrl: storagePath,
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
      imagePaths: updatedImagePaths,
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .doc(visit.id)
        .set(updatedModel.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteVisit(String visitId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (visitId.isEmpty) {
      throw Exception('Visit ID cannot be empty for deletion.');
    }

    // Clean up Supabase Storage attachments associated with this visit
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('visits')
          .doc(visitId)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final data = docSnapshot.data()!;
        final List<String> pathsToDelete = [];

        if (data['imagePaths'] is List) {
          pathsToDelete.addAll(
            (data['imagePaths'] as List).map((e) => e.toString()),
          );
        }

        if (data['attachments'] is List) {
          for (final item in (data['attachments'] as List)) {
            if (item is Map &&
                item['fileUrl'] is String &&
                (item['fileUrl'] as String).isNotEmpty) {
              final urlOrPath = item['fileUrl'] as String;
              if (!pathsToDelete.contains(urlOrPath) &&
                  !urlOrPath.startsWith('http')) {
                pathsToDelete.add(urlOrPath);
              }
            }
          }
        }

        if (pathsToDelete.isNotEmpty) {
          await _storageService.deleteImages(
            bucket: SupabaseConfig.visitImagesBucket,
            paths: pathsToDelete,
          );
        }
      }
    } catch (_) {
      // Continue with document deletion so user is not blocked
    }

    // Delete the Firestore document
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .doc(visitId)
        .delete();
  }

  @override
  Future<void> deleteVisitImage({
    required String visitId,
    required String storagePath,
  }) async {
    await _checkConnectivity();
    final userId = _getUserId();

    // 1. Delete file from Supabase Storage
    try {
      await _storageService.deleteImage(
        bucket: SupabaseConfig.visitImagesBucket,
        path: storagePath,
      );
    } catch (_) {
      // Best-effort storage deletion
    }

    // 2. Remove references from Firestore visit document
    final visitDocRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('visits')
        .doc(visitId);

    final docSnapshot = await visitDocRef.get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      final List<dynamic> imagePaths = List.from(data['imagePaths'] ?? []);
      imagePaths.remove(storagePath);

      final List<dynamic> attachments = List.from(data['attachments'] ?? []);
      attachments.removeWhere(
        (att) =>
            att is Map &&
            (att['fileUrl'] == storagePath || att['id'] == storagePath),
      );

      await visitDocRef.update({
        'imagePaths': imagePaths,
        'attachments': attachments,
      });
    }
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
