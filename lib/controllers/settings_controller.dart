import 'package:get/get.dart';
import '../services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  
  final RxBool soundEnabled = true.obs;
  final RxBool vibrationEnabled = true.obs;
  final RxString language = 'ar'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    soundEnabled.value = _storage.getBool('sound_enabled') ?? true;
    vibrationEnabled.value = _storage.getBool('vibration_enabled') ?? true;
    language.value = _storage.getString('language') ?? 'ar';
  }

  Future<void> toggleSound(bool value) async {
    soundEnabled.value = value;
    await _storage.setBool('sound_enabled', value);
  }

  Future<void> toggleVibration(bool value) async {
    vibrationEnabled.value = value;
    await _storage.setBool('vibration_enabled', value);
  }

  Future<void> changeLanguage(String lang) async {
    language.value = lang;
    await _storage.setString('language', lang);
  }
}