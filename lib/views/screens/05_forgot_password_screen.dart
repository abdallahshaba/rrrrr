import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/validators.dart';
import '../../../utils/helpers.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
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
                  Icons.lock_reset,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'إرسال',
                  onPressed: _resetPassword,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });
      
      Helpers.showSuccessSnackbar('تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني');
      Get.back();
    }
  }
}