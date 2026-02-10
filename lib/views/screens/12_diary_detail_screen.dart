import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/diary_entry_model.dart';
import '../../../utils/helpers.dart';
import '../../../utils/constants.dart';

class DiaryDetailScreen extends StatelessWidget {
  const DiaryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entry = Get.arguments is DiaryEntryModel 
        ? Get.arguments as DiaryEntryModel 
        : null;

    if (entry == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'تفاصيل اليومية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error, size: 40, color: Colors.red),
              ),
              const SizedBox(height: 24),
              const Text(
                'لم يتم تمرير بيانات اليومية!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'الرجاء العودة والمحاولة مرة أخرى',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // تحديد لون القالب بناءً على المزاج
    final moodColor = entry.moodLevel != null 
        ? Helpers.getMoodColor(entry.moodLevel!) 
        : Colors.blue[400]!;
    final gradientColors = [
      moodColor.withOpacity(0.08),
      moodColor.withOpacity(0.03),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            entry.title.isNotEmpty ? entry.title : 'يومية جديدة',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black87),
              onPressed: () => Get.toNamed(RoutesConfig.editDiary, arguments: entry),
              tooltip: 'تعديل',
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: Column(
              children: [
                // ========== البطاقة الرئيسية ==========
                _buildHeaderCard(entry, moodColor),
                
                const SizedBox(height: 24),
                
                // ========== المحتوى داخل حاوية بيضاء ==========
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========== المشاعر ==========
                      if (_hasEmotions(entry)) _buildEmotionsSection(entry),
                      
                      // ========== الدوافع ==========
                      if (_hasUrges(entry)) _buildUrgeSection(entry),
                      
                      // ========== السلوكيات ==========
                      if (_hasBehaviors(entry)) _buildBehaviorsSection(entry),
                      
                      // ========== المهارات ==========
                      if (entry.skillsUsed != null && entry.skillsUsed!.isNotEmpty)
                        _buildSkillsSection(entry),
                      
                      // ========== النوم ==========
                      if (entry.sleepHours != null) _buildSleepSection(entry),
                      
                      // ========== الملاحظات ==========
                      if (entry.notes != null && entry.notes!.isNotEmpty)
                        _buildNotesSection(entry),
                      
                      // ========== المحتوى الرئيسي ==========
                      const SizedBox(height: 28),
                      _buildContentSection(entry),
                      
                      // ========== الوسوم ==========
                      if (entry.tags != null && entry.tags!.isNotEmpty)
                        _buildTagsSection(entry),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== البطاقة الرئيسية مع العنوان والتاريخ ==========
  Widget _buildHeaderCard(DiaryEntryModel entry, Color moodColor) {
    final emoji = entry.moodLevel != null && entry.moodLevel! > 0 && entry.moodLevel! <= 10
        ? AppConstants.moodEmojis[entry.moodLevel! - 1]
        : '📝';
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            moodColor.withOpacity(0.12),
            moodColor.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: moodColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الإيموجي الكبير
          Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(height: 16),
          
          // العنوان
          Text(
            entry.title.isNotEmpty ? entry.title : 'بدون عنوان',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // التاريخ
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: moodColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: moodColor),
                  const SizedBox(width: 6),
                  Text(
                    Helpers.formatDateTime(entry.createdAt),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                      color: moodColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // إذا تم التعديل
          if (entry.updatedAt != null) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'عُدّل ${Helpers.getTimeAgo(entry.updatedAt!)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== قسم المشاعر بتصميم دائري ==========
  Widget _buildEmotionsSection(DiaryEntryModel entry) {
    final emotions = <Widget>[];
    
    // الحزن
    if (entry.sadnessLevel != null && entry.sadnessLevel! > 0) {
      emotions.add(_buildRadialEmotionItem(
        icon: Icons.water_drop,
        color: const Color(0xFF5E81AC),
        label: 'الحزن',
        level: entry.sadnessLevel!,
      ));
    }
    
    // القلق
    if (entry.anxietyLevel != null && entry.anxietyLevel! > 0) {
      emotions.add(_buildRadialEmotionItem(
        icon: Icons.blur_circular,
        color: const Color(0xFFD08770),
        label: 'القلق',
        level: entry.anxietyLevel!,
      ));
    }
    
    // الغضب
    if (entry.angerLevel != null && entry.angerLevel! > 0) {
      emotions.add(_buildRadialEmotionItem(
        icon: Icons.whatshot,
        color: const Color(0xFFBF616A),
        label: 'الغضب',
        level: entry.angerLevel!,
      ));
    }
    
    // الخجل
    if (entry.shameLevel != null && entry.shameLevel! > 0) {
      emotions.add(_buildRadialEmotionItem(
        icon: Icons.visibility_off,
        color: const Color(0xFFB48EAD),
        label: 'الخجل/الندم',
        level: entry.shameLevel!,
      ));
    }
    
    if (emotions.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('المشاعر', Icons.favorite_border),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: emotions,
        ),
      ],
    );
  }

  Widget _buildRadialEmotionItem({
    required IconData icon,
    required Color color,
    required String label,
    required int level,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // دائرة التقدم الشعاعي
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: level / 10,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200]!,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Icon(icon, size: 28, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$level/10',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ========== قسم الدوافع ==========
  Widget _buildUrgeSection(DiaryEntryModel entry) {
    final urges = <Widget>[];
    
    // الهدوء (إيجابي)
    if (entry.calmnessLevel != null && entry.calmnessLevel! > 0) {
      urges.add(_buildUrgeCard(
        icon: Icons.spa,
        color: const Color(0xFF88C9A1),
        label: 'الهدوء',
        level: entry.calmnessLevel!,
        isPositive: true,
      ));
    }
    
    // إيذاء النفس
    if (entry.selfHarmUrge != null && entry.selfHarmUrge! > 0) {
      urges.add(_buildUrgeCard(
        icon: Icons.healing,
        color: const Color(0xFFBF616A),
        label: 'إيذاء النفس',
        level: entry.selfHarmUrge!,
        isPositive: false,
      ));
    }
    
    // الأفكار الانتحارية
    if (entry.suicidalUrge != null && entry.suicidalUrge! > 0) {
      urges.add(_buildUrgeCard(
        icon: Icons.medical_services,
        color: const Color(0xFFB48EAD),
        label: 'الأفكار الانتحارية',
        level: entry.suicidalUrge!,
        isPositive: false,
      ));
    }
    
    if (urges.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('الدوافع', Icons.thermostat),
        const SizedBox(height: 16),
        ...urges,
      ],
    );
  }

  Widget _buildUrgeCard({
    required IconData icon,
    required Color color,
    required String label,
    required int level,
    required bool isPositive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(isPositive ? 0.15 : 0.1),
            color.withOpacity(isPositive ? 0.05 : 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive 
                      ? const Color(0xFF88C9A1).withOpacity(0.2) 
                      : const Color(0xFFBF616A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  isPositive ? 'إيجابي' : 'تحذير',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    color: isPositive ? const Color(0xFF88C9A1) : const Color(0xFFBF616A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // شريط التقدم مع تدرج لوني
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: level / 10,
              minHeight: 10,
              backgroundColor: Colors.grey[200]!,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPositive ? const Color(0xFF88C9A1) : const Color(0xFFBF616A),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الشدة: $level/10',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
              Text(
                _getLevelDescription(level),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLevelDescription(int level) {
    if (level <= 3) return 'منخفض';
    if (level <= 6) return 'متوسط';
    return 'مرتفع';
  }

  // ========== السلوكيات ==========
  Widget _buildBehaviorsSection(DiaryEntryModel entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('السلوكيات', Icons.psychology),
        const SizedBox(height: 16),
        
        // السلوكيات السلبية
        if (entry.negativeBehaviors != null && entry.negativeBehaviors!.isNotEmpty)
          _buildBehaviorGroup(
            title: 'السلوكيات السلبية',
            items: entry.negativeBehaviors!,
            color: const Color(0xFFBF616A),
            icon: Icons.cancel,
          ),
        
        // السلوكيات الإيجابية
        if (entry.positiveBehaviors != null && entry.positiveBehaviors!.isNotEmpty)
          _buildBehaviorGroup(
            title: 'السلوكيات الإيجابية',
            items: entry.positiveBehaviors!,
            color: const Color(0xFF88C9A1),
            icon: Icons.check_circle,
          ),
      ],
    );
  }

  Widget _buildBehaviorGroup({
    required String title,
    required List<String> items,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 14, color: color),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ========== المهارات ==========
  Widget _buildSkillsSection(DiaryEntryModel entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('المهارات المستخدمة', Icons.self_improvement),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: entry.skillsUsed!.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF88C9A1), Color(0xFF5E81AC)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ========== النوم ==========
  Widget _buildSleepSection(DiaryEntryModel entry) {
    if (entry.sleepHours == null) return const SizedBox();
    
    final hours = entry.sleepHours!;
    final color = hours >= 7 
        ? const Color(0xFF88C9A1) 
        : hours >= 5 
            ? const Color(0xFFEBCB8B) 
            : const Color(0xFFBF616A);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('النوم', Icons.bed),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(Icons.bed, size: 40, color: color),
              const SizedBox(height: 16),
              Text(
                '$hours ساعة',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getSleepQuality(hours),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _getSleepAdvice(hours),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSleepQuality(int hours) {
    if (hours >= 8) return 'نوم ممتاز 💤';
    if (hours >= 7) return 'نوم جيد ✅';
    if (hours >= 6) return 'نوم مقبول ⚠️';
    return 'نوم غير كافٍ ❌';
  }

  String _getSleepAdvice(int hours) {
    if (hours >= 8) return 'أحسنت! جسمك وعقلك يشكرانك على الراحة الكافية.';
    if (hours >= 7) return 'جيد جداً! تحافظ على توازن صحي للنوم.';
    if (hours >= 6) return 'حاول زيادة وقت النوم 30-60 دقيقة لتحسين طاقتك اليومية.';
    return 'النوم القليل يؤثر على مزاجك وتركيزك. حاول النوم 7-9 ساعات يومياً.';
  }

  // ========== الملاحظات ==========
  Widget _buildNotesSection(DiaryEntryModel entry) {
    if (entry.notes == null || entry.notes!.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ملاحظات إضافية', Icons.notes),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(20),
           
          ),
          child: Text(
            entry.notes!,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'Cairo',
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ========== المحتوى الرئيسي ==========
  Widget _buildContentSection(DiaryEntryModel entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('المحتوى', Icons.article),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            entry.content.isNotEmpty ? entry.content : 'لا يوجد محتوى',
            style: const TextStyle(
              fontSize: 17,
              height: 1.7,
              fontFamily: 'Cairo',
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // ========== الوسوم ==========
  Widget _buildTagsSection(DiaryEntryModel entry) {
    if (entry.tags == null || entry.tags!.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('الوسوم', Icons.label),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: entry.tags!.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB48EAD), Color(0xFF81A1C1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ========== رأس القسم ==========
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF5E81AC).withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF5E81AC)),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ========== التحقق من وجود بيانات ==========
  bool _hasEmotions(DiaryEntryModel entry) {
    return (entry.sadnessLevel != null && entry.sadnessLevel! > 0) ||
           (entry.anxietyLevel != null && entry.anxietyLevel! > 0) ||
           (entry.angerLevel != null && entry.angerLevel! > 0) ||
           (entry.shameLevel != null && entry.shameLevel! > 0);
  }

  bool _hasUrges(DiaryEntryModel entry) {
    return (entry.calmnessLevel != null && entry.calmnessLevel! > 0) ||
           (entry.selfHarmUrge != null && entry.selfHarmUrge! > 0) ||
           (entry.suicidalUrge != null && entry.suicidalUrge! > 0);
  }

  bool _hasBehaviors(DiaryEntryModel entry) {
    return (entry.negativeBehaviors != null && entry.negativeBehaviors!.isNotEmpty) ||
           (entry.positiveBehaviors != null && entry.positiveBehaviors!.isNotEmpty);
  }
}