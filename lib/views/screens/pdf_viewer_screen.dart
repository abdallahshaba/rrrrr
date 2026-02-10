import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final File pdfFile = Get.arguments as File;
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5E81AC),
          foregroundColor: Colors.white,
          title: const Text(
            'معاينة التقرير',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _sharePdf,
              tooltip: 'مشاركة',
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadPdf,
              tooltip: 'حفظ',
            ),
          ],
        ),
        body: Stack(
          children: [
            PDFView(
              filePath: pdfFile.path,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                  isReady = true;
                });
              },
              onError: (error) {
                Get.snackbar(
                  'خطأ',
                  'فشل تحميل ملف PDF',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              },
              onPageError: (page, error) {
                Get.snackbar(
                  'خطأ',
                  'فشل تحميل الصفحة $page',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              },
              onViewCreated: (PDFViewController pdfViewController) {
                // يمكن حفظ ال controller للاستخدام لاحقاً
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page ?? 0;
                });
              },
            ),
            if (!isReady)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5E81AC),
                ),
              ),
          ],
        ),
        bottomNavigationBar: isReady
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E81AC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'صفحة ${currentPage + 1} من $totalPages',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5E81AC),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }

  void _sharePdf() async {
    try {
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'تقرير المزاج من تطبيق DBT Wellness',
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشلت عملية المشاركة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _downloadPdf() {
    Get.snackbar(
      'تم الحفظ',
      'تم حفظ الملف في: ${pdfFile.path}',
      backgroundColor: const Color(0xFF88C9A1),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}