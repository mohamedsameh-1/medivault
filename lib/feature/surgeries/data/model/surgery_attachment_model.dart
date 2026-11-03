import '../../domain/entities/surgery_attachment_entity.dart';

class SurgeryAttachmentModel extends SurgeryAttachmentEntity {
  const SurgeryAttachmentModel({
    required super.id,
    required super.fileName,
    super.fileUrl,
    super.fileType = 'image',
    super.fileSize,
    super.localPath,
  });

  factory SurgeryAttachmentModel.fromJson(Map<String, dynamic> json) {
    return SurgeryAttachmentModel(
      id: json['id'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'],
      fileType: json['fileType'] ?? 'image',
      fileSize: (json['fileSize'] as num?)?.toInt(),
      localPath: json['localPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileSize': fileSize,
    };
  }

  factory SurgeryAttachmentModel.fromEntity(SurgeryAttachmentEntity entity) {
    return SurgeryAttachmentModel(
      id: entity.id,
      fileName: entity.fileName,
      fileUrl: entity.fileUrl,
      fileType: entity.fileType,
      fileSize: entity.fileSize,
      localPath: entity.localPath,
    );
  }
}

