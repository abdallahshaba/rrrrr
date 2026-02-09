import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final savedTheme = _storage.getString(AppConfig.keyThemeMode);
    if (savedTheme != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.setString(AppConfig.keyThemeMode, mode.toString());
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}