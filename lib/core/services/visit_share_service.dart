import 'dart:io';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../feature/add_visit/domain/entities/visit_attachment_entity.dart';
import '../../feature/add_visit/domain/entities/visit_entity.dart';
import '../utils/app_strings.dart';

@injectable
class VisitShareService {
  final ArabicReshaper _reshaper = ArabicReshaper();

  /// Generates a medical visit report PDF and opens the native share sheet.
  Future<void> shareVisitReport({
    required VisitEntity visit,
    required String specialtyTitle,
  }) async {
    final pdfBytes = await generateVisitPdf(
      visit: visit,
      specialtyTitle: specialtyTitle,
    );

    final tempDir = await getTemporaryDirectory();
    final fileName =
        'medical_visit_${visit.id ?? DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsBytes(pdfBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: '${AppStrings.medicalVisitReport.tr()} - ${visit.doctorName}',
    );
  }

  /// Generates the raw PDF bytes for a given [visit].
  Future<Uint8List> generateVisitPdf({
    required VisitEntity visit,
    required String specialtyTitle,
  }) async {
    // 1. Load Arabic + Latin capable font from assets
    final regularFontData =
        await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/Tajawal-Bold.ttf');

    final ttfRegular = pw.Font.ttf(regularFontData);
    final ttfBold = pw.Font.ttf(boldFontData);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: ttfRegular,
        bold: ttfBold,
      ),
    );

    // 2. Fetch image attachment bytes safely
    final List<pw.MemoryImage> imageList = [];
    final imageAttachments = visit.attachments.where(_isImageAttachment);

    for (final attachment in imageAttachments) {
      final bytes = await _loadImageBytes(attachment);
      if (bytes != null && bytes.isNotEmpty) {
        try {
          final pdfImage = pw.MemoryImage(bytes);
          imageList.add(pdfImage);
        } catch (_) {
          // Ignore corrupted images
        }
      }
    }

    final formattedVisitDate =
        DateFormat('MMM dd, yyyy').format(visit.visitDate);
    final formattedReportDate =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    // 3. Build PDF Document Pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPdfHeader(formattedReportDate),
        footer: (context) => _buildPdfFooter(context),
        build: (context) => [
          pw.SizedBox(height: 12),

          // Title Section
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F0FDFA'),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              border: pw.Border.all(color: PdfColor.fromHex('#CCFBF1')),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildText(
                  AppStrings.medicalVisitReport.tr().toUpperCase(),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#006758'),
                ),
                pw.SizedBox(height: 4),
                _buildText(
                  specialtyTitle,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#1E293B'),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Consultation Details Section
          _buildPdfSectionHeader(AppStrings.consultationInformation.tr()),
          pw.SizedBox(height: 8),

          _buildInfoRow(AppStrings.visitDate.tr(), formattedVisitDate),
          if (visit.doctorName.trim().isNotEmpty) ...[
            pw.SizedBox(height: 6),
            _buildInfoRow(AppStrings.doctorName.tr(), visit.doctorName),
          ],
          if (visit.clinicHospital.trim().isNotEmpty) ...[
            pw.SizedBox(height: 6),
            _buildInfoRow(
                AppStrings.clinicHospital.tr(), visit.clinicHospital),
          ],

          pw.SizedBox(height: 14),

          // Symptoms
          if (visit.symptoms.trim().isNotEmpty) ...[
            _buildPdfSectionHeader(AppStrings.symptoms.tr()),
            pw.SizedBox(height: 6),
            _buildContentBox(visit.symptoms),
            pw.SizedBox(height: 14),
          ],

          // Diagnosis
          if (visit.diagnosis.trim().isNotEmpty) ...[
            _buildPdfSectionHeader(AppStrings.doctorDiagnosis.tr()),
            pw.SizedBox(height: 6),
            _buildContentBox(visit.diagnosis),
            pw.SizedBox(height: 14),
          ],

          // Optional Advisory Notes (included ONLY if non-empty)
          if (visit.advisoryNotes != null &&
              visit.advisoryNotes!.trim().isNotEmpty) ...[
            _buildPdfSectionHeader(AppStrings.advisoryNotes.tr()),
            pw.SizedBox(height: 6),
            _buildContentBox(visit.advisoryNotes!),
            pw.SizedBox(height: 14),
          ],

          // Optional Prescriptions (included ONLY if non-empty)
          if (visit.prescriptions != null &&
              visit.prescriptions!.trim().isNotEmpty) ...[
            _buildPdfSectionHeader(AppStrings.prescriptions.tr()),
            pw.SizedBox(height: 6),
            _buildContentBox(visit.prescriptions!),
            pw.SizedBox(height: 14),
          ],

          // Optional Medical Images Section (included ONLY if images exist and loaded)
          if (imageList.isNotEmpty) ...[
            _buildPdfSectionHeader(AppStrings.medicalAttachments.tr()),
            pw.SizedBox(height: 10),
            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: imageList.map((img) {
                return pw.Container(
                  constraints: const pw.BoxConstraints(
                    maxHeight: 220,
                    maxWidth: 240,
                  ),
                  decoration: pw.BoxDecoration(
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(8)),
                    border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0')),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 8,
                    verticalRadius: 8,
                    child: pw.Image(img, fit: pw.BoxFit.contain),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildPdfHeader(String formattedReportDate) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildText(
              'MediVault',
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromHex('#006758'),
            ),
            _buildText(
              formattedReportDate,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Divider(color: PdfColor.fromHex('#006758'), thickness: 1),
      ],
    );
  }

  pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: _buildText(
        '${context.pageNumber} / ${context.pagesCount}',
        fontSize: 9,
        color: PdfColors.grey600,
      ),
    );
  }

  pw.Widget _buildPdfSectionHeader(String title) {
    return _buildText(
      title,
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColor.fromHex('#006758'),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    final bool isLabelArabic = _containsArabic(label);
    final bool isValueArabic = _containsArabic(value);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: _buildText(
            '$label:',
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.Expanded(
          child: _buildText(
            value,
            fontSize: 10,
            color: PdfColors.black,
            textDirection: isValueArabic || isLabelArabic
                ? pw.TextDirection.rtl
                : pw.TextDirection.ltr,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildContentBox(String text) {
    final bool isArabic = _containsArabic(text);

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F8FAFC'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColor.fromHex('#E2E8F0')),
      ),
      child: _buildText(
        text,
        fontSize: 10,
        color: PdfColors.black,
        lineSpacing: 1.3,
        textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      ),
    );
  }

  pw.Widget _buildText(
    String text, {
    double fontSize = 10,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    double lineSpacing = 1.0,
    pw.TextDirection? textDirection,
  }) {
    final bool hasArabic = _containsArabic(text);
    final String processedText = hasArabic ? _reshaper.reshape(text) : text;
    final pw.TextDirection dir =
        textDirection ?? (hasArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr);

    return pw.Text(
      processedText,
      textDirection: dir,
      style: pw.TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        lineSpacing: lineSpacing,
      ),
    );
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  bool _isImageAttachment(VisitAttachmentEntity attachment) {
    final type = attachment.fileType.toLowerCase();
    final name = attachment.fileName.toLowerCase();
    return type == 'image' ||
        name.endsWith('.jpg') ||
        name.endsWith('.png') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.webp');
  }

  Future<Uint8List?> _loadImageBytes(VisitAttachmentEntity attachment) async {
    // 1. Check local path
    if (attachment.localPath != null && attachment.localPath!.isNotEmpty) {
      try {
        final file = File(attachment.localPath!);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      } catch (_) {
        // Fall back to url if available
      }
    }

    // 2. Check remote file URL
    if (attachment.fileUrl != null && attachment.fileUrl!.isNotEmpty) {
      try {
        final client = HttpClient();
        client.connectionTimeout = const Duration(seconds: 10);
        final request = await client.getUrl(Uri.parse(attachment.fileUrl!));
        final response = await request.close();

        if (response.statusCode == 200) {
          final bytes = await response.fold<List<int>>(
            <int>[],
            (previous, element) => previous..addAll(element),
          );
          client.close();
          return Uint8List.fromList(bytes);
        }
        client.close();
      } catch (_) {
        // Safe handle download failure
      }
    }

    return null;
  }
}
