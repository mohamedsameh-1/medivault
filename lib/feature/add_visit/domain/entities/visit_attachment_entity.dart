class VisitAttachmentEntity {
  final String id;
  final String fileName;
  final String? fileUrl;
  final String fileType; // "image" or "pdf"
  final int? fileSize;
  final String? localPath;

  const VisitAttachmentEntity({
    required this.id,
    required this.fileName,
    this.fileUrl,
    required this.fileType,
    this.fileSize,
    this.localPath,
  });
}
