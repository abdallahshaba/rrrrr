import 'package:flutter/material.dart';

class AppConstants {
  // ========== Padding & Spacing ==========
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // ========== Border Radius ==========
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // ========== Icon Sizes ==========
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // ========== Font Sizes ==========
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
  
  // ========== Mood Emojis (10 مستويات من 1 إلى 10) ==========
  static const List<String> moodEmojis = [
    '😭', // 1 - سيء جداً
    '😢', // 2 - سيء
    '😞', // 3 - حزين
    '😔', // 4 - غير مرتاح
    '😐', // 5 - محايد
    '🙂', // 6 - جيد نوعاً ما
    '😊', // 7 - جيد
    '😄', // 8 - جيد جداً
    '😁', // 9 - رائع
    '😍', // 10 - في قمة السعادة
  ];
  
  // ========== Mood Labels (10 مستويات) ==========
  static const List<String> moodLabels = [
    'سيء جداً',
    'سيء',
    'حزين',
    'غير مرتاح',
    'محايد',
    'جيد نوعاً ما',
    'جيد',
    'جيد جداً',
    'رائع',
    'في قمة السعادة'
  ];
  
  // ========== الوسوم الافتراضية ==========
  static const List<String> defaultTags = [
    'قلق',
    'حزن',
    'غضب',
    'توتر',
    'هدوء',
    'سعادة',
    'إرهاق',
    'إحباط',
    'أمل',
    'امتنان',
    'وحدة',
    'طاقة منخفضة',
    'تركيز منخفض',
    'صعوبة في النوم',
  ];
  
  // ========== السلوكيات السلبية ==========
  static const List<String> negativeBehaviors = [
    'العزلة الاجتماعية',
    'إهمال النظافة الشخصية',
    'عدم تناول الطعام',
    'الأكل المفرط',
    'الصراخ أو الغضب',
    'إيذاء النفس',
    'إلغاء المواعيد',
    'إدمان وسائل التواصل',
    'عدم ممارسة الرياضة',
    'التفكير السلبي المتكرر',
    'إهمال الأدوية',
    'الهروب من المواقف',
  ];
  
  // ========== السلوكيات الإيجابية ==========
  static const List<String> positiveBehaviors = [
    'التأمل أو اليقظة الذهنية',
    'المشي أو ممارسة الرياضة',
    'التحدث مع صديق موثوق',
    'كتابة اليوميات',
    'الاستحمام أو العناية بالنفس',
    'تناول وجبة صحية',
    'النوم المبكر',
    'ممارسة هواية مفضلة',
    'طلب الدعم النفسي',
    'ممارسة تمارين التنفس',
    'الامتنان اليومي',
    'وضع حدود صحية',
  ];
  
  // ========== مهارات DBT الأساسية ==========
  static const List<String> dbtSkills = [
    'اليقظة الذهنية (Mindfulness)',
    'تحمل الضيق (Distress Tolerance)',
    'تنظيم المشاعر (Emotion Regulation)',
    ' العلاقة بفاعلية (Interactive relationship)',
    'تمارين التنفس',
    ' grounding (الارتباط باللحظة الحالية)',
    'التحقق من الحقائق',
    'عكس العواطف',
    'التفكير المتوازن',
    'التعامل مع الأفكار التلقائية',
  ];
  
  // ========== DBT Skills Icons ==========
  static const Map<String, IconData> skillIcons = {
    'اليقظة الذهنية (Mindfulness)': Icons.self_improvement,
    'تحمل الضيق (Distress Tolerance)': Icons.shield,
    ' تنظيم المشاعر  (Emotion Regulation)': Icons.favorite,
    'الفعالية الشخصية (Interpersonal Effectiveness)': Icons.people,
    'تمارين التنفس': Icons.air,
    'grounding (الارتباط باللحظة الحالية)': Icons.location_on,
    'التحقق من الحقائق': Icons.rule,
    'عكس العواطف': Icons.autorenew,
    'التفكير المتوازن': Icons.balance,
    'التعامل مع الأفكار التلقائية': Icons.lightbulb,
  };
  
  // ========== ألوان التطبيق ==========
  static const Color primaryColor = Color(0xFF4361ee);
  static const Color secondaryColor = Color(0xFF3f37c9);
  static const Color accentColor = Color(0xFF4895ef);
  static const Color successColor = Color(0xFF4cc9f0);
  static const Color warningColor = Color(0xFFF72585);
  static const Color errorColor = Color(0xFFd62828);
  static const Color infoColor = Color(0xFF7209b7);
  
  // ========== Animation Durations ==========
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}