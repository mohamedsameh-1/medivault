import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class MediaPickerService {
  /// Captures a new photo using the device camera.
  Future<File?> pickImageFromCamera({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  });

  /// Picks one or more images from the device gallery.
  Future<List<File>> pickImagesFromGallery({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  });

  /// Picks a single image from the device gallery.
  Future<File?> pickSingleImageFromGallery({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  });
}

@Injectable(as: MediaPickerService)
class MediaPickerServiceImpl implements MediaPickerService {
  final ImagePicker _picker;

  MediaPickerServiceImpl({
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pickImageFromCamera({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      if (pickedFile == null) return null;
      final file = File(pickedFile.path);
      return await file.exists() ? file : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<File>> pickImagesFromGallery({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      final List<File> files = [];
      for (final xFile in pickedFiles) {
        final file = File(xFile.path);
        if (await file.exists()) {
          files.add(file);
        }
      }
      return files;
    } catch (_) {
      return [];
    }
  }

  @override
  Future<File?> pickSingleImageFromGallery({
    int imageQuality = 85,
    double? maxWidth = 1920,
    double? maxHeight = 1920,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      if (pickedFile == null) return null;
      final file = File(pickedFile.path);
      return await file.exists() ? file : null;
    } catch (_) {
      return null;
    }
  }
}

