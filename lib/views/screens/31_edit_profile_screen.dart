import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/validators.dart';
import '../../../utils/helpers.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _nameController.text = _authController.currentUser.value?.name ?? '';
    _phoneController.text = _authController.currentUser.value?.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              label: 'الاسم',
              controller: _nameController,
              prefixIcon: Icons.person,
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'رقم الهاتف',
              controller: _phoneController,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'حفظ التعديلات',
              onPressed: _saveProfile,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await _authController.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      Helpers.showSuccessSnackbar('تم تحديث الملف الشخصي');
      Get.back();
    }
  }
}