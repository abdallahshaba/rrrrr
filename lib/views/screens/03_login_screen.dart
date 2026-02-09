import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/utils/validators.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthController());
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'مرحباً بعودتك',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'سجّل دخولك للمتابعة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Get.toNamed(RoutesConfig.forgotPassword),
                    child: const Text('نسيت كلمة المرور؟'),
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => CustomButton(
                  text: 'تسجيل الدخول',
                  onPressed: _login,
                  isLoading: _authController.isLoading.value,
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟ ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => Get.toNamed(RoutesConfig.register),
                      child: const Text('سجّل الآن'),
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

  void _login() async {
    if (_formKey.currentState!.validate()) {
      await _authController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}