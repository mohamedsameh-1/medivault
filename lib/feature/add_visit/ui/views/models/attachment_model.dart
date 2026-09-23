class AttachmentModel {
  final String id;
  final String fileName;
  final String categoryTag;
  final String fileSize;
  final String? thumbnailPath;
  final bool isPdf;

  const AttachmentModel({
    required this.id,
    required this.fileName,
    required this.categoryTag,
    required this.fileSize,
    this.thumbnailPath,
    this.isPdf = false,
  });

  static const List<AttachmentModel> initialSampleAttachments = [
    AttachmentModel(
      id: '1',
      fileName: 'Dr_Ahmed_Prescription_...',
      categoryTag: 'Rx/Recip',
      fileSize: '1.4 MB',
      isPdf: false,
    ),
    AttachmentModel(
      id: '2',
      fileName: 'Cardiology_ECG_Strip.pdf',
      categoryTag: 'Lab & ECG',
      fileSize: '2.1 MB',
      isPdf: true,
    ),
  ];
}
