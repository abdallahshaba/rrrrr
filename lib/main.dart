import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/config/theme_config.dart';
import 'package:dbt_mental_health_app/controllers/theme_controller.dart';
import 'package:dbt_mental_health_app/services/database_service.dart';
import 'package:dbt_mental_health_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  await initializeServices();
  
  runApp(const DBTMentalHealthApp());
}

Future<void> initializeServices() async {
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => DatabaseService().init());
  Get.put(ThemeController());
}

class DBTMentalHealthApp extends StatelessWidget {
  const DBTMentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    
    return Obx(() => GetMaterialApp(
      title: 'DBT Wellness',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: themeController.themeMode.value,
      initialRoute: RoutesConfig.splash,
      getPages: RoutesConfig.routes,
      
      // ✨ الحل السحري: تطبيق الخط والاتجاه العربي على كامل التطبيق في خطوة واحدة
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // دعم كامل للعربية (يمين لليسار)
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontFamily: 'Cairo', // اسم الخط المُعرّف في pubspec.yaml
              // ⚠️ لا تحدد لون أو حجم هنا — دع الثيم يتحكم فيهما تلقائياً
            ),
            child: child!,
          ),
        );
      },
    ));
  }
}