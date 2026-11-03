import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:medivault/core/config/supabase_config.dart';
import 'package:medivault/core/services/supabase_storage_service.dart';
import 'package:medivault/feature/surgeries/domain/entities/surgery_attachment_entity.dart';
import '../../model/surgery_model.dart';
import '../contract/surgeries_remote_data_source.dart';

@Injectable(as: SurgeriesRemoteDataSource)
class SurgeriesRemoteDataSourceImpl implements SurgeriesRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final SupabaseStorageService _storageService;
  final Connectivity _connectivity;

  SurgeriesRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    required SupabaseStorageService storageService,
    Connectivity? connectivity,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storageService = storageService,
       _connectivity = connectivity ?? Connectivity();

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

  @override
  Future<List<SurgeryModel>> getSurgeries() async {
    await _checkConnectivity();
    final userId = _getUserId();

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .orderBy('surgeryDate', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => SurgeryModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<SurgeryModel> getSurgeryDetails(String surgeryId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(surgeryId)
        .get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      throw Exception('Surgery record not found.');
    }

    return SurgeryModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
  }

  @override
  Future<void> addSurgery(SurgeryModel surgery) async {
    await _checkConnectivity();
    final userId = _getUserId();

    final List<String> successfullyUploadedPaths = [];

    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('surgeries')
          .doc();

      final docId = docRef.id;
      final List<SurgeryAttachmentEntity> finalAttachments = [];
      final List<String> finalImagePaths = [];

      for (final attachment in surgery.attachments) {
        if (attachment.localPath != null && attachment.localPath!.isNotEmpty) {
          final file = File(attachment.localPath!);
          if (await file.exists()) {
            final safeName = attachment.fileName.replaceAll(
              RegExp(r'[^a-zA-Z0-9._-]'),
              '_',
            );
            final uniqueFileName =
                '${DateTime.now().millisecondsSinceEpoch}_$safeName';
            final storagePath = '$userId/$docId/$uniqueFileName';

            await _storageService.uploadImage(
              bucket: SupabaseConfig.surgeryImagesBucket,
              path: storagePath,
              file: file,
            );

            successfullyUploadedPaths.add(storagePath);
            finalImagePaths.add(storagePath);

            finalAttachments.add(
              SurgeryAttachmentEntity(
                id: attachment.id,
                fileName: attachment.fileName,
                fileUrl: storagePath,
                fileType: 'image',
                fileSize: attachment.fileSize,
                localPath: attachment.localPath,
              ),
            );
          }
        } else if (attachment.fileUrl != null &&
            attachment.fileUrl!.isNotEmpty) {
          finalAttachments.add(attachment);
          finalImagePaths.add(attachment.fileUrl!);
        }
      }

      final finalModel = SurgeryModel(
        id: docId,
        surgeryName: surgery.surgeryName,
        specialty: surgery.specialty,
        surgeryDate: surgery.surgeryDate,
        doctorName: surgery.doctorName,
        hospitalName: surgery.hospitalName,
        diagnosis: surgery.diagnosis,
        // anesthesiaType: surgery.anesthesiaType,
        notes: surgery.notes,
        attachments: finalAttachments,
        imagePaths: finalImagePaths,
        createdAt: DateTime.now(),
      );

      await docRef.set(finalModel.toFirestore());
    } catch (e) {
      if (successfullyUploadedPaths.isNotEmpty) {
        try {
          await _storageService.deleteImages(
            bucket: SupabaseConfig.surgeryImagesBucket,
            paths: successfullyUploadedPaths,
          );
        } catch (_) {
          // Best-effort cleanup
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> updateSurgery(SurgeryModel surgery) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (surgery.id.isEmpty) {
      throw Exception('Surgery ID cannot be empty for update.');
    }

    final docId = surgery.id;
    final List<String> successfullyUploadedPaths = [];

    try {
      final List<SurgeryAttachmentEntity> finalAttachments = [];
      final List<String> finalImagePaths = [];

      for (final attachment in surgery.attachments) {
        if (attachment.localPath != null && attachment.localPath!.isNotEmpty) {
          final file = File(attachment.localPath!);
          if (await file.exists()) {
            final safeName = attachment.fileName.replaceAll(
              RegExp(r'[^a-zA-Z0-9._-]'),
              '_',
            );
            final uniqueFileName =
                '${DateTime.now().millisecondsSinceEpoch}_$safeName';
            final storagePath = '$userId/$docId/$uniqueFileName';

            await _storageService.uploadImage(
              bucket: SupabaseConfig.surgeryImagesBucket,
              path: storagePath,
              file: file,
            );

            successfullyUploadedPaths.add(storagePath);
            finalImagePaths.add(storagePath);

            finalAttachments.add(
              SurgeryAttachmentEntity(
                id: attachment.id,
                fileName: attachment.fileName,
                fileUrl: storagePath,
                fileType: 'image',
                fileSize: attachment.fileSize,
                localPath: attachment.localPath,
              ),
            );
          }
        } else if (attachment.fileUrl != null &&
            attachment.fileUrl!.isNotEmpty) {
          finalAttachments.add(attachment);
          finalImagePaths.add(attachment.fileUrl!);
        }
      }

      final finalModel = SurgeryModel(
        id: docId,
        surgeryName: surgery.surgeryName,
        specialty: surgery.specialty,
        surgeryDate: surgery.surgeryDate,
        doctorName: surgery.doctorName,
        hospitalName: surgery.hospitalName,
        diagnosis: surgery.diagnosis,
        // anesthesiaType: surgery.anesthesiaType,
        notes: surgery.notes,
        attachments: finalAttachments,
        imagePaths: finalImagePaths,
        createdAt: surgery.createdAt ?? DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('surgeries')
          .doc(docId)
          .set(finalModel.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      if (successfullyUploadedPaths.isNotEmpty) {
        try {
          await _storageService.deleteImages(
            bucket: SupabaseConfig.surgeryImagesBucket,
            paths: successfullyUploadedPaths,
          );
        } catch (_) {
          // Best-effort cleanup
        }
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteSurgery(String surgeryId) async {
    await _checkConnectivity();
    final userId = _getUserId();

    if (surgeryId.isEmpty) {
      throw Exception('Surgery ID cannot be empty for deletion.');
    }

    // Cascade delete: remove all files from Supabase Storage first
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('surgeries')
          .doc(surgeryId)
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
              final path = item['fileUrl'] as String;
              if (!pathsToDelete.contains(path) && !path.startsWith('http')) {
                pathsToDelete.add(path);
              }
            } else if (item is String &&
                item.isNotEmpty &&
                !item.startsWith('http') &&
                !pathsToDelete.contains(item)) {
              pathsToDelete.add(item);
            }
          }
        }

        if (pathsToDelete.isNotEmpty) {
          await _storageService.deleteImages(
            bucket: SupabaseConfig.surgeryImagesBucket,
            paths: pathsToDelete,
          );
        }
      }
    } catch (_) {
      // Continue with Firestore deletion so user is not blocked
    }

    // Delete Firestore document
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(surgeryId)
        .delete();
  }

  @override
  Future<void> deleteSurgeryImage({
    required String surgeryId,
    required String storagePath,
  }) async {
    await _checkConnectivity();
    final userId = _getUserId();

    // 1. Delete file from Supabase Storage
    try {
      await _storageService.deleteImage(
        bucket: SupabaseConfig.surgeryImagesBucket,
        path: storagePath,
      );
    } catch (_) {
      // Best-effort storage deletion
    }

    // 2. Remove references from Firestore surgery document
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('surgeries')
        .doc(surgeryId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;

      final List<dynamic> imagePaths = List.from(data['imagePaths'] ?? []);
      imagePaths.remove(storagePath);

      final List<dynamic> attachments = List.from(data['attachments'] ?? []);
      attachments.removeWhere(
        (att) =>
            (att is Map &&
                (att['fileUrl'] == storagePath || att['id'] == storagePath)) ||
            (att is String && att == storagePath),
      );

      await docRef.update({
        'imagePaths': imagePaths,
        'attachments': attachments,
      });
    }
  }
}
