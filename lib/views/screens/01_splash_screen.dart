import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../config/app_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final storage = Get.find<StorageService>();
    final isFirstTime = storage.getBool(AppConfig.keyIsFirstTime) ?? true;
    final userId = storage.getInt(AppConfig.keyUserId);
    
    if (isFirstTime) {
      Get.offAllNamed(RoutesConfig.onboarding);
    } else if (userId != null) {
      Get.offAllNamed(RoutesConfig.main);
    } else {
      Get.offAllNamed(RoutesConfig.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'DBT Wellness',
                style: TextAppStyles.boldtextStyle22 ,
              ),
              const SizedBox(height: 8),
               Text(
                'رحلتك نحو الصحة النفسية',
                style: TextAppStyles.regulartextStyle16
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}