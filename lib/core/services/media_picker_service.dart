import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class MediaPickerService {
  /// Captures a new photo using the device camera.
  Future<File?> pickImageFromCamera({int imageQuality = 85});

  /// Picks one or more images from the device gallery.
  Future<List<File>> pickImagesFromGallery({int imageQuality = 85});

  /// Picks a single image from the device gallery.
  Future<File?> pickSingleImageFromGallery({int imageQuality = 85});
}

@Injectable(as: MediaPickerService)
class MediaPickerServiceImpl implements MediaPickerService {
  final ImagePicker _picker;

  MediaPickerServiceImpl({
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pickImageFromCamera({int imageQuality = 85}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      if (pickedFile == null) return null;
      final file = File(pickedFile.path);
      return await file.exists() ? file : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<File>> pickImagesFromGallery({int imageQuality = 85}) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
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
  Future<File?> pickSingleImageFromGallery({int imageQuality = 85}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      if (pickedFile == null) return null;
      final file = File(pickedFile.path);
      return await file.exists() ? file : null;
    } catch (_) {
      return null;
    }
  }
}

