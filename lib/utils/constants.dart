import 'package:flutter/material.dart';

class AppConstants {
  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Icon Sizes
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // Font Sizes
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
  
  // Mood Emojis
  static const List<String> moodEmojis = [
    '😢', '😞', '😕', '😐', '🙂', '😊', '😃', '😄', '😁', '🤩'
  ];
  
  // Mood Labels
  static const List<String> moodLabels = [
    'سيء جداً',
    'سيء',
    'غير جيد',
    'محايد',
    'جيد نوعاً ما',
    'جيد',
    'جيد جداً',
    'رائع',
    'ممتاز',
    'في قمة السعادة'
  ];
  
  // DBT Skills Icons
  static const Map<String, IconData> skillIcons = {
    'اليقظة الذهنية': Icons.self_improvement,
    'تحمل الضيق': Icons.shield,
    'تنظيم العواطف': Icons.favorite,
    'الفعالية الشخصية': Icons.people,
  };
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}