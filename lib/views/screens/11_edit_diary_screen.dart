import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_text_field.dart';
import 'package:dbt_mental_health_app/views/widgets/mood_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/diary_controller.dart';
import '../../../models/diary_entry_model.dart';
import '../../../utils/validators.dart';
import '../../../utils/helpers.dart';


class EditDiaryScreen extends StatefulWidget {
  const EditDiaryScreen({super.key});

  @override
  State<EditDiaryScreen> createState() => _EditDiaryScreenState();
}

class _EditDiaryScreenState extends State<EditDiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _controller = Get.find<DiaryController>();
  late DiaryEntryModel entry;
  int? _moodLevel;

  @override
  void initState() {
    super.initState();
    entry = Get.arguments as DiaryEntryModel;
    _titleController.text = entry.title;
    _contentController.text = entry.content;
    _moodLevel = entry.moodLevel;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل اليومية')),
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
              'المزاج',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MoodSlider(
              initialValue: _moodLevel ?? 5,
              onChanged: (value) {
                _moodLevel = value;
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'حفظ التعديلات',
              onPressed: _updateDiary,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  void _updateDiary() async {
    if (_formKey.currentState!.validate()) {
      await _controller.updateEntry(
        id: entry.id!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        moodLevel: _moodLevel,
      );
      
      Helpers.showSuccessSnackbar('تم تحديث اليومية');
      Get.back();
    }
  }
}