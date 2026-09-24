import '../../domain/entities/visit_attachment_entity.dart';

class VisitAttachmentModel extends VisitAttachmentEntity {
  const VisitAttachmentModel({
    required super.id,
    required super.fileName,
    super.fileUrl,
    required super.fileType,
    required super.fileSize,
    super.localPath,
  });

  factory VisitAttachmentModel.fromJson(Map<String, dynamic> json) {
    //     Future<int?> getFileSize() async {
    //   return (json['fileSize'] as num?)?.toInt();
    // }
    return VisitAttachmentModel(
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

  factory VisitAttachmentModel.fromEntity(VisitAttachmentEntity entity) {
    return VisitAttachmentModel(
      id: entity.id,
      fileName: entity.fileName,
      fileUrl: entity.fileUrl,
      fileType: entity.fileType,
      fileSize: entity.fileSize,
      localPath: entity.localPath,
    );
  }
}
