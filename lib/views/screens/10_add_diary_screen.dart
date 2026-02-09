import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:dbt_mental_health_app/views/widgets/mood_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/diary_controller.dart';
import '../../../utils/validators.dart';
import '../../../utils/helpers.dart';


class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key});

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _controller = Get.find<DiaryController>();
  int? _moodLevel;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('يومية جديدة')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'العنوان',
              controller: _titleController,
              validator: (value) => Validators.validateRequired(value, 'العنوان'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'المحتوى',
              controller: _contentController,
              maxLines: 10,
              maxLength: 5000,
              validator: (value) => Validators.validateRequired(value, 'المحتوى'),
            ),
            const SizedBox(height: 24),
            const Text(
              'كيف كان مزاجك؟ (اختياري)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MoodSlider(
              onChanged: (value) {
                _moodLevel = value;
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'حفظ',
              onPressed: _saveDiary,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  void _saveDiary() async {
    if (_formKey.currentState!.validate()) {
      await _controller.addEntry(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        moodLevel: _moodLevel,
      );
      
      Helpers.showSuccessSnackbar('تم حفظ اليومية');
      Get.back();
    }
  }
}