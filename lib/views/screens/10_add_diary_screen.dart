import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../widgets/mood_selector_widget.dart';
import 'package:dbt_mental_health_app/controllers/diary_controller.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key});

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  // ✅ تعريف جميع المتحكمات هنا في كلاس الحالة
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // ✅ المتغيرات للبيانات
  int? _selectedMoodLevel;
  List<String> _selectedTags = [];
  double _sadnessLevel = 0;
  double _anxietyLevel = 0;
  double _angerLevel = 0;
  double _shameLevel = 0;
  double _selfHarmUrge = 0;
  double _suicidalUrge = 0;
  double _calmnessLevel = 0;
  List<String> _selectedNegativeBehaviors = [];
  List<String> _selectedPositiveBehaviors = [];
  List<String> _selectedSkills = [];
  int? _sleepHours;

  final DiaryController _diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    super.initState();
    _selectedMoodLevel = 3; // افتراضي: مزاج متوسط
    _sleepHours = 7; // افتراضي: 7 ساعات
  }

  @override
  void dispose() {
    // ✅ تحرير الذاكرة
    _titleController.dispose();
    _contentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveDiary() async {
    // ✅ التحقق من الحد الأدنى (العنوان مطلوب)
    if (_titleController.text.trim().isEmpty) {
      Helpers.showErrorSnackbar('العنوان مطلوب');
      return;
    }

    // ✅ حفظ البيانات باستخدام الدالة الصحيحة التي تحفظ جميع الحقول
    await _diaryController.addDiaryEntry(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      moodLevel: _selectedMoodLevel,
      tags: _selectedTags.isNotEmpty ? _selectedTags : null,
      sadnessLevel: _sadnessLevel > 0 ? _sadnessLevel.toInt() : null,
      anxietyLevel: _anxietyLevel > 0 ? _anxietyLevel.toInt() : null,
      angerLevel: _angerLevel > 0 ? _angerLevel.toInt() : null,
      shameLevel: _shameLevel > 0 ? _shameLevel.toInt() : null,
      selfHarmUrge: _selfHarmUrge > 0 ? _selfHarmUrge.toInt() : null,
      suicidalUrge: _suicidalUrge > 0 ? _suicidalUrge.toInt() : null,
      calmnessLevel: _calmnessLevel > 0 ? _calmnessLevel.toInt() : null,
      negativeBehaviors: _selectedNegativeBehaviors.isNotEmpty 
          ? _selectedNegativeBehaviors 
          : null,
      positiveBehaviors: _selectedPositiveBehaviors.isNotEmpty 
          ? _selectedPositiveBehaviors 
          : null,
      skillsUsed: _selectedSkills.isNotEmpty ? _selectedSkills : null,
      sleepHours: _sleepHours,
      notes: _notesController.text.trim().isNotEmpty 
          ? _notesController.text.trim() 
          : null,
    );

    Helpers.showSuccessSnackbar('تم حفظ اليومية بنجاح');
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إضافة يومية جديدة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveDiary,
              tooltip: 'حفظ',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== العنوان ==========
              _buildTextField(
                controller: _titleController,
                label: 'العنوان',
                hint: 'اكتب عنواناً ليوميتك...',
                maxLines: 1,
              ),
              
              const SizedBox(height: 20),
              
              // ========== المزاج ==========
              _buildSection(
                title: 'المزاج العام',
                child: MoodSelectorWidget(
                  selectedMood: _selectedMoodLevel ?? 3,
                  onMoodSelected: (mood) {
                    setState(() => _selectedMoodLevel = mood);
                  },
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== المشاعر ==========
              _buildSection(
                title: 'المشاعر',
                child: Column(
                  children: [
                    _buildEmotionSlider(
                      label: 'الحزن',
                      icon: Icons.sentiment_dissatisfied,
                      color: Colors.blue[400]!,
                      value: _sadnessLevel,
                      onChanged: (v) => setState(() => _sadnessLevel = v),
                    ),
                    _buildEmotionSlider(
                      label: 'القلق',
                      icon: Icons.panorama_fish_eye,
                      color: Colors.orange[400]!,
                      value: _anxietyLevel,
                      onChanged: (v) => setState(() => _anxietyLevel = v),
                    ),
                    _buildEmotionSlider(
                      label: 'الغضب',
                      icon: Icons.sentiment_very_dissatisfied,
                      color: Colors.red[400]!,
                      value: _angerLevel,
                      onChanged: (v) => setState(() => _angerLevel = v),
                    ),
                    _buildEmotionSlider(
                      label: 'الخجل/الندم',
                      icon: Icons.emoji_events,
                      color: Colors.purple[400]!,
                      value: _shameLevel,
                      onChanged: (v) => setState(() => _shameLevel = v),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== الدوافع ==========
              _buildSection(
                title: 'الدوافع',
                child: Column(
                  children: [
                    _buildEmotionSlider(
                      label: 'الهدوء',
                      icon: Icons.self_improvement,
                      color: Colors.green[400]!,
                      value: _calmnessLevel,
                      onChanged: (v) => setState(() => _calmnessLevel = v),
                      isPositive: true,
                    ),
                    _buildEmotionSlider(
                      label: 'إيذاء النفس',
                      icon: Icons.warning,
                      color: Colors.red[400]!,
                      value: _selfHarmUrge,
                      onChanged: (v) => setState(() => _selfHarmUrge = v),
                    ),
                    _buildEmotionSlider(
                      label: 'الأفكار الانتحارية',
                      icon: Icons.report,
                      color: Colors.deepPurple[400]!,
                      value: _suicidalUrge,
                      onChanged: (v) => setState(() => _suicidalUrge = v),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== السلوكيات ==========
              _buildSection(
                title: 'السلوكيات',
                child: Column(
                  children: [
                    _buildBehaviorSelector(
                      title: 'السلوكيات السلبية',
                      behaviors: AppConstants.negativeBehaviors,
                      selected: _selectedNegativeBehaviors,
                      onSelected: (behavior) {
                        setState(() {
                          if (_selectedNegativeBehaviors.contains(behavior)) {
                            _selectedNegativeBehaviors.remove(behavior);
                          } else {
                            _selectedNegativeBehaviors.add(behavior);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildBehaviorSelector(
                      title: 'السلوكيات الإيجابية',
                      behaviors: AppConstants.positiveBehaviors,
                      selected: _selectedPositiveBehaviors,
                      onSelected: (behavior) {
                        setState(() {
                          if (_selectedPositiveBehaviors.contains(behavior)) {
                            _selectedPositiveBehaviors.remove(behavior);
                          } else {
                            _selectedPositiveBehaviors.add(behavior);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== المهارات ==========
              _buildSection(
                title: 'المهارات المستخدمة',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.dbtSkills.map((skill) {
                    final isSelected = _selectedSkills.contains(skill);
                    return ChoiceChip(
                      label: Text(
                        skill,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSkills.add(skill);
                          } else {
                            _selectedSkills.remove(skill);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== النوم ==========
              _buildSection(
                title: 'ساعات النوم',
                child: Column(
                  children: [
                    Text(
                      '$_sleepHours ساعة',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Slider(
                      value: _sleepHours?.toDouble() ?? 7,
                      min: 0,
                      max: 12,
                      divisions: 12,
                      label: '${_sleepHours ?? 7} ساعة',
                      onChanged: (value) {
                        setState(() => _sleepHours = value.toInt());
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // ========== المحتوى ==========
              _buildTextField(
                controller: _contentController,
                label: 'المحتوى',
                hint: 'اكتب تفاصيل يوميتك هنا...',
                maxLines: 8,
              ),
              
              const SizedBox(height: 20),
              
              // ========== الملاحظات ==========
              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات إضافية',
                hint: 'أي ملاحظات أخرى...',
                maxLines: 4,
              ),
              
              const SizedBox(height: 20),
              
              // ========== الوسوم ==========
              _buildSection(
                title: 'الوسوم',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.defaultTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveDiary,
          icon: const Icon(Icons.save),
          label: const Text('حفظ اليومية'),
        ),
      ),
    );
  }

  // ========== ويدجتات مساعدة ==========
  
  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    );
  }

  Widget _buildEmotionSlider({
    required String label,
    required IconData icon,
    required Color color,
    required double value,
    required ValueChanged<double> onChanged,
    bool isPositive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 10,
            label: value.toInt().toString(),
            activeColor: color,
            inactiveColor: color.withOpacity(0.3),
            onChanged: onChanged,
          ),
          Text(
            'الشدة: ${value.toInt()} من 10',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorSelector({
    required String title,
    required List<String> behaviors,
    required List<String> selected,
    required ValueChanged<String> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: behaviors.map((behavior) {
            final isSelected = selected.contains(behavior);
            return ChoiceChip(
              label: Text(
                behavior,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              selected: isSelected,
              onSelected: (selected) => onSelected(behavior),
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[100],
            );
          }).toList(),
        ),
      ],
    );
  }
}