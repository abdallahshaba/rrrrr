import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helpers {
  // Date Formatting
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
  }
  
  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
  
  // Snackbar Messages
  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'نجح',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  static void showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  static void showInfoSnackbar(String message) {
    Get.snackbar(
      'معلومة',
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  // Dialogs
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText),
          ),
        ],
      ),
    ) ?? false;
  }
  
  // Get Mood Color
  static Color getMoodColor(int mood) {
    if (mood <= 3) return Colors.red;
    if (mood <= 5) return Colors.orange;
    if (mood <= 7) return Colors.yellow;
    return Colors.green;
  }
  
  // Calculate Percentage
  static double calculatePercentage(int current, int total) {
    if (total == 0) return 0.0;
    return (current / total) * 100;
  }
}