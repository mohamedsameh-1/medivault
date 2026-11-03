import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

abstract class SupabaseStorageService {
  /// Uploads [file] to [bucket] at the given [path].
  ///
  /// Returns the relative storage path inside the bucket.
  Future<String> uploadImage({
    required String bucket,
    required String path,
    required File file,
  });

  /// Generates a temporary signed URL to securely read a private file at [path].
  Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresInSeconds = SupabaseConfig.signedUrlExpiresInSeconds,
  });

  /// Deletes a single file at [path] in [bucket].
  Future<void> deleteImage({required String bucket, required String path});

  /// Deletes multiple files at [paths] in [bucket].
  Future<void> deleteImages({
    required String bucket,
    required List<String> paths,
  });
}

@Injectable(as: SupabaseStorageService)
class SupabaseStorageServiceImpl implements SupabaseStorageService {
  final FirebaseAuth _firebaseAuth;

  SupabaseStorageServiceImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  SupabaseClient get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      throw Exception(
        'Supabase is not initialized. Please supply SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
      );
    }
  }

  /// Synchronizes the current Firebase user's identity token into Supabase client headers.
  ///
  /// When Third-Party Auth / Custom JWKS is configured in Supabase, this enables
  /// Storage Row Level Security (RLS) policies to verify `auth.jwt() ->> 'sub'`
  /// against the Firebase user ID securely.
  Future<void> _prepareAuthHeaders() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        if (token != null && token.isNotEmpty) {
          _client.rest.headers['Authorization'] = 'Bearer $token';
          _client.storage.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (_) {
      // If token refresh fails, continue with default headers and let RLS enforce access
    }
  }

  @override
  Future<String> uploadImage({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await _prepareAuthHeaders();
    await _client.storage
        .from(bucket)
        .upload(path, file, fileOptions: const FileOptions(upsert: false));
    return path;
  }

  @override
  Future<String> getSignedUrl({
    required String bucket,
    required String path,
    int expiresInSeconds = SupabaseConfig.signedUrlExpiresInSeconds,
  }) async {
    await _prepareAuthHeaders();
    final signedUrl = await _client.storage
        .from(bucket)
        .createSignedUrl(path, expiresInSeconds);
    return signedUrl;
  }

  @override
  Future<void> deleteImage({
    required String bucket,
    required String path,
  }) async {
    await _prepareAuthHeaders();
    await _client.storage.from(bucket).remove([path]);
  }

  @override
  Future<void> deleteImages({
    required String bucket,
    required List<String> paths,
  }) async {
    if (paths.isEmpty) return;
    await _prepareAuthHeaders();
    await _client.storage.from(bucket).remove(paths);
  }
}
