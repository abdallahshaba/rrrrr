import 'dart:ui';

class AppConfig {
  // App Information
  static const String appName = 'DBT Wellness';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'تطبيق شامل للعلاج السلوكي الجدلي والصحة النفسية';
  
  // Database
  static const String databaseName = 'dbt_wellness.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  
  // AI Assistant Configuration
  static const String aiApiEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const String aiModel = 'gpt-3.5-turbo';
  
  // Mood Scale
  static const int moodMin = 1;
  static const int moodMax = 10;
  
  // Goals
  static const int maxActiveGoals = 10;
  
  // Notifications
  static const int dailyReminderHour = 20;
  static const int dailyReminderMinute = 0;
  static const int medicationReminderAdvanceMinutes = 15;
  
  // PDF Export
  static const String pdfAuthor = 'DBT Wellness App';
  static const String pdfCreator = 'Flutter PDF Package';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayTimeFormat = 'hh:mm a';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxDiaryCharacters = 5000;
  static const int maxGoalCharacters = 200;
  
  // Skills Categories
  static const List<String> skillsCategories = [
    'اليقظة الذهنية',
    'تحمل الضيق',
    'تنظيم العواطف',
    'الفعالية الشخصية',
  ];
  
  // Emergency Contacts
  static const String emergencyHotline = '988';
  static const String crisisTextLine = '741741';
}

