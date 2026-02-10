import 'package:dbt_mental_health_app/views/screens/03_login_screen.dart';
import 'package:dbt_mental_health_app/views/screens/04_register_screen.dart';
import 'package:dbt_mental_health_app/views/screens/05_forgot_password_screen.dart';
import 'package:dbt_mental_health_app/views/screens/07_home_screen.dart';
import 'package:dbt_mental_health_app/views/screens/08_dashboard_screen.dart';
import 'package:dbt_mental_health_app/views/screens/09_diary_screen.dart';
import 'package:dbt_mental_health_app/views/screens/10_add_diary_screen.dart';
import 'package:dbt_mental_health_app/views/screens/11_edit_diary_screen.dart';
import 'package:dbt_mental_health_app/views/screens/12_diary_detail_screen.dart';
import 'package:dbt_mental_health_app/views/screens/13_skills_library_screen.dart';
import 'package:dbt_mental_health_app/views/screens/14_mindfulness_screen.dart';
import 'package:dbt_mental_health_app/views/screens/15_distress_tolerance_screen.dart';
import 'package:dbt_mental_health_app/views/screens/16_emotion_regulation_screen.dart';
import 'package:dbt_mental_health_app/views/screens/17_interpersonal_screen.dart';
import 'package:dbt_mental_health_app/views/screens/18_skill_detail_screen.dart';
import 'package:dbt_mental_health_app/views/screens/19_skill_practice_screen.dart';
import 'package:dbt_mental_health_app/views/screens/20_sos_screen.dart';
import 'package:dbt_mental_health_app/views/screens/21_crisis_guide_screen.dart';
import 'package:dbt_mental_health_app/views/screens/22_breathing_exercise_screen.dart';
import 'package:dbt_mental_health_app/views/screens/23_grounding_exercise_screen.dart';
import 'package:dbt_mental_health_app/views/screens/24_tipp_skills_screen.dart';
import 'package:dbt_mental_health_app/views/screens/25_reports_screen.dart';
import 'package:dbt_mental_health_app/views/screens/26_weekly_report_screen.dart';
import 'package:dbt_mental_health_app/views/screens/27_mood_chart_screen.dart';
import 'package:dbt_mental_health_app/views/screens/28_progress_screen.dart';
import 'package:dbt_mental_health_app/views/screens/29_export_pdf_screen.dart';
import 'package:dbt_mental_health_app/views/screens/30_profile_screen.dart';
import 'package:dbt_mental_health_app/views/screens/31_edit_profile_screen.dart';
import 'package:dbt_mental_health_app/views/screens/32_settings_screen.dart';
import 'package:dbt_mental_health_app/views/screens/33_notifications_screen.dart';
import 'package:dbt_mental_health_app/views/screens/34_theme_screen.dart';
import 'package:dbt_mental_health_app/views/screens/35_about_screen.dart';
import 'package:dbt_mental_health_app/views/screens/pdf_viewer_screen.dart';
import 'package:dbt_mental_health_app/views/screens/sleep_tracker_screen.dart';
import 'package:get/get.dart';

import '../views/screens/01_splash_screen.dart';
import '../views/screens/02_onboarding_screen.dart';
import '../views/screens/06_main_screen.dart';
import '../views/screens/ai_assistant_screen.dart';
import '../views/screens/goals_screen.dart';
import '../views/screens/achievements_screen.dart';
import '../views/screens/medication_screen.dart';
import '../views/screens/add_medication_screen.dart';
import '../views/screens/nutrition_screen.dart';
import '../views/screens/exercise_screen.dart';
import '../views/screens/extras/calendar_screen.dart';
import '../views/screens/gratitude/gratitude_journal_screen.dart';

class RoutesConfig {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Main Routes
  static const String pdfViewer = '/pdf-viewer';
  static const String main = '/main';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  
  // Diary Routes
  static const String diary = '/diary';
  static const String addDiary = '/add-diary';
  static const String editDiary = '/edit-diary';
  static const String diaryDetail = '/diary-detail';
  
  // Skills Routes
  static const String skillsLibrary = '/skills-library';
  static const String mindfulness = '/mindfulness';
  static const String distressTolerance = '/distress-tolerance';
  static const String emotionRegulation = '/emotion-regulation';
  static const String interpersonal = '/interpersonal';
  static const String skillDetail = '/skill-detail';
  static const String skillPractice = '/skill-practice';
  
  // SOS Routes
  static const String sos = '/sos';
  static const String crisisGuide = '/crisis-guide';
  static const String breathingExercise = '/breathing-exercise';
  static const String groundingExercise = '/grounding-exercise';
  static const String tippSkills = '/tipp-skills';
  
  // Reports Routes
  static const String reports = '/reports';
  static const String weeklyReport = '/weekly-report';
  static const String moodChart = '/mood-chart';
  static const String progress = '/progress';
  static const String exportPdf = '/export-pdf';
  
  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String theme = '/theme';
  static const String about = '/about';
  
  // Feature Routes
  static const String aiAssistant = '/ai-assistant';
  static const String goals = '/goals';
  static const String achievements = '/achievements';
  static const String medication = '/medication';
  static const String addMedication = '/add-medication';
  static const String nutrition = '/nutrition';
  static const String exercise = '/exercise';
  static const String sleepTracker = '/sleep-tracker';
  static const String calendar = '/calendar';
  static const String gratitudeJournal = '/gratitude-journal';
  
  // Define all routes
  static final List<GetPage> routes = [
    // Auth & Onboarding
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    
    // Main
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: pdfViewer, page: () => const PdfViewerScreen()),

    
    // Diary
    GetPage(name: diary, page: () => const DiaryScreen()),
    GetPage(name: addDiary, page: () => const AddDiaryScreen()),
    GetPage(name: editDiary, page: () => const EditDiaryScreen()),
    GetPage(name: diaryDetail, page: () => const DiaryDetailScreen()),
    
    // Skills
    GetPage(name: skillsLibrary, page: () => const SkillsLibraryScreen()),
    GetPage(name: mindfulness, page: () => const MindfulnessScreen()),
    GetPage(name: distressTolerance, page: () => const DistressToleranceScreen()),
    GetPage(name: emotionRegulation, page: () => const EmotionRegulationScreen()),
    GetPage(name: interpersonal, page: () => const InterpersonalScreen()),
    GetPage(name: skillDetail, page: () => const SkillDetailScreen()),
    GetPage(name: skillPractice, page: () => const SkillPracticeScreen()),
    
    // SOS
    GetPage(name: sos, page: () => const SOSScreen()),
    GetPage(name: crisisGuide, page: () => const CrisisGuideScreen()),
    GetPage(name: breathingExercise, page: () => const BreathingExerciseScreen()),
    GetPage(name: groundingExercise, page: () => const GroundingExerciseScreen()),
    GetPage(name: tippSkills, page: () => const TippSkillsScreen()),
    
    // Reports
    GetPage(name: reports, page: () => const ReportsScreen()),
    GetPage(name: weeklyReport, page: () => const WeeklyReportScreen()),
    GetPage(name: moodChart, page: () => const MoodChartScreen()),
    GetPage(name: progress, page: () => const ProgressScreen()),
    GetPage(name: exportPdf, page: () => const ExportPdfScreen()),
    
    // Profile
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => const EditProfileScreen()),
    GetPage(name: settings, page: () => const SettingsScreen()),
    // GetPage(name: notifications, page: () => const NotificationsScreen()),
    GetPage(name: theme, page: () => const ThemeScreen()),
    GetPage(name: about, page: () => const AboutScreen()),
    
    // Features
    GetPage(name: aiAssistant, page: () => const AIAssistantScreen()),
    GetPage(name: goals, page: () => const GoalsScreen()),
    GetPage(name: achievements, page: () => const AchievementsScreen()),
    GetPage(name: medication, page: () => const MedicationScreen()),
    GetPage(name: addMedication, page: () => const AddMedicationScreen()),
    GetPage(name: nutrition, page: () => const NutritionScreen()),
    GetPage(name: exercise, page: () => const ExerciseScreen()),
    GetPage(name: sleepTracker, page: () => const SleepTrackerScreen()),
    GetPage(name: calendar, page: () => const CalendarScreen()),
    GetPage(name: gratitudeJournal, page: () => const GratitudeJournalScreen()),
  ];
}