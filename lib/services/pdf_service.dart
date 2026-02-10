import 'dart:io';
import 'package:dbt_mental_health_app/models/mood_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/helpers.dart';

class PdfService {
  Future<File> generateMoodReport({
    required String userName,
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> moodData,
    required double averageMood,
    required int totalEntries,
    required List<MoodModel> moodDataa,
  }) async {
    final pdf = pw.Document();
    
    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#5E81AC'),
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'تقرير المزاج الشهري',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'DBT Wellness App',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.white70,
                  ),
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 24),
          
          // User Info
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromHex('#E4E7EB')),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow('المستخدم:', userName, arabicFontBold),
                pw.SizedBox(height: 8),
                _buildInfoRow(
                  'الفترة:',
                  '${Helpers.formatDate(startDate)} - ${Helpers.formatDate(endDate)}',
                  arabicFontBold,
                ),
                pw.SizedBox(height: 8),
                _buildInfoRow('تاريخ التقرير:', Helpers.formatDate(DateTime.now()), arabicFontBold),
              ],
            ),
          ),
          
          pw.SizedBox(height: 24),
          
          // Statistics
          pw.Text(
            'الإحصائيات',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildStatBox('متوسط المزاج', averageMood.toStringAsFixed(1), PdfColor.fromHex('#88C9A1')),
              _buildStatBox('عدد التسجيلات', totalEntries.toString(), PdfColor.fromHex('#5E81AC')),
              _buildStatBox(
                'أعلى مزاج',
                moodData.isNotEmpty
                    ? moodDataa.map((m) => m.moodLevel).reduce((a, b) => a > b ? a : b).toString()
                    : '0',
                PdfColor.fromHex('#88C9A1'),
              ),
            ],
          ),
          
          pw.SizedBox(height: 24),
          
          // Mood Table
          pw.Text(
            'سجل المزاج التفصيلي',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          
          pw.Table(
            border: pw.TableBorder.all(color: PdfColor.fromHex('#E4E7EB')),
            children: [
              // Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F8F9FC')),
                children: [
                  _buildTableCell('التاريخ', isHeader: true),
                  _buildTableCell('المزاج', isHeader: true),
                  _buildTableCell('الملاحظات', isHeader: true),
                ],
              ),
              // Data rows
              ...moodDataa.map((mood) => pw.TableRow(
                children: [
                  _buildTableCell(Helpers.formatDate(mood.timestamp)),
                  _buildTableCell('${mood.moodLevel}/10'),
                  _buildTableCell(mood.note ?? '-'),
                ],
              )),
            ],
          ),
          
          pw.SizedBox(height: 24),
          
          // Footer
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F8F9FC'),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'ملاحظات:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  '• استمر في تتبع مزاجك يومياً للحصول على نتائج أفضل',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '• مارس مهارات DBT بانتظام',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '• في حالة الحاجة للمساعدة الفورية، استخدم خاصية SOS',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/mood_report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }

  pw.Widget _buildInfoRow(String label, String value, pw.Font boldFont) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildStatBox(String label, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: color.flatten(),
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: color, width: 2),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 14 : 12,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  Future<void> printPdf(File pdfFile) async {
    await Printing.layoutPdf(onLayout: (_) => pdfFile.readAsBytes());
  }

  Future<void> sharePdf(File pdfFile) async {
    await Printing.sharePdf(
      bytes: await pdfFile.readAsBytes(),
      filename: 'mood_report.pdf',
    );
  }
}