import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/validators.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'انضم إلينا',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'أنشئ حسابك وابدأ رحلتك',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'الاسم الكامل',
                  controller: _nameController,
                  prefixIcon: Icons.person,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock,
                  suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  onSuffixTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'تأكيد كلمة المرور',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock,
                  suffixIcon: _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  onSuffixTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Obx(() => CustomButton(
                  text: 'إنشاء حساب',
                  onPressed: _register,
                  isLoading: _authController.isLoading.value,
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟ ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('سجّل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      await _authController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}