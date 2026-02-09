
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../config/app_config.dart';
import '../config/routes_config.dart';

class AuthController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final StorageService _storage = Get.find<StorageService>();
  
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final userId = _storage.getInt(AppConfig.keyUserId);
    if (userId != null) {
      await loadUser(userId);
    }
  }

  Future<void> loadUser(int userId) async {
    final users = await _db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (users.isNotEmpty) {
      currentUser.value = UserModel.fromMap(users.first);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final user = UserModel(
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      
      final userId = await _db.insert('users', user.toMap());
      
      await _storage.setInt(AppConfig.keyUserId, userId);
      await _storage.setString(AppConfig.keyUserEmail, email);
      await _storage.setString(AppConfig.keyUserName, name);
      
      await loadUser(userId);
      
      Get.offAllNamed(RoutesConfig.main);
      
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل التسجيل');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final users = await _db.query('users', where: 'email = ?', whereArgs: [email]);
      
      if (users.isEmpty) {
        Get.snackbar('خطأ', 'البريد الإلكتروني غير مسجل');
        return false;
      }
      
      final user = UserModel.fromMap(users.first);
      
      await _storage.setInt(AppConfig.keyUserId, user.id!);
      await _storage.setString(AppConfig.keyUserEmail, email);
      await _storage.setString(AppConfig.keyUserName, user.name);
      
      currentUser.value = user;
      
      Get.offAllNamed('${RoutesConfig.main}');
      
      return true;
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الدخول');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.remove(AppConfig.keyUserId);
    await _storage.remove(AppConfig.keyUserEmail);
    await _storage.remove(AppConfig.keyUserName);
    
    currentUser.value = null;
    
    Get.offAllNamed(RoutesConfig.login);
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
  }) async {
    if (currentUser.value == null) return;
    
    final updatedUser = currentUser.value!.copyWith(
      name: name,
      phone: phone,
      updatedAt: DateTime.now(),
    );
    
    await _db.update(
      'users',
      updatedUser.toMap(),
      where: 'id = ?',
      whereArgs: [updatedUser.id],
    );
    
    currentUser.value = updatedUser;
    await _storage.setString(AppConfig.keyUserName, name);
  }
}