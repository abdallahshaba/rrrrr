import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  Future<File> generateMoodReport({
    required String userName,
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> moodData,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('تقرير المزاج', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Text('المستخدم: $userName'),
          pw.Text('الفترة: ${startDate.toString().split(' ')[0]} - ${endDate.toString().split(' ')[0]}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['التاريخ', 'المزاج', 'الملاحظات'],
            data: moodData.map((mood) => [
              mood['date'],
              mood['level'].toString(),
              mood['note'] ?? '-',
            ]).toList(),
          ),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/mood_report.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }

  Future<void> printPdf(File pdfFile) async {
    await Printing.layoutPdf(onLayout: (_) => pdfFile.readAsBytes());
  }

  Future<void> sharePdf(File pdfFile) async {
    await Printing.sharePdf(bytes: await pdfFile.readAsBytes(), filename: 'report.pdf');
  }
}