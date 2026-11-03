class SurgeryAttachmentEntity {
  final String id;
  final String fileName;
  final String? fileUrl;
  final String fileType; // "image"
  final int? fileSize;
  final String? localPath;

  const SurgeryAttachmentEntity({
    required this.id,
    required this.fileName,
    this.fileUrl,
    this.fileType = 'image',
    this.fileSize,
    this.localPath,
  });
}

