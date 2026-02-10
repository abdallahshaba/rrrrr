import 'package:dbt_mental_health_app/models/diary_entry_model.dart';
import 'package:dbt_mental_health_app/models/goal_model.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:dbt_mental_health_app/views/widgets/mood_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../config/routes_config.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final authController = Get.find<AuthController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: _buildAppBar(authController),
        body: Obx(() {
          if (homeController.isLoading.value) {
            return const _LoadingState();
          }
          return _buildContent(homeController);
        }),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AuthController authController) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Obx(() => Text(
        'مرحباً، ${authController.currentUser.value?.name ?? "عزيزي"}',
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black87,
        ),
      )),
      actions: [
        IconButton(
          icon: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF5E81AC).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_outlined, color: Color(0xFF5E81AC)),
          ),
          onPressed: () => Get.toNamed(RoutesConfig.notifications),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildContent(HomeController controller) {
    return RefreshIndicator(
      onRefresh: controller.loadData,
      color: const Color(0xFF5E81AC),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          // مساحة فارغة للتنفس البصري
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          
          // بطاقة المزاج اليومي
          SliverToBoxAdapter(child: _buildMoodSection(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
          // الإجراءات السريعة
          SliverToBoxAdapter(child: _buildQuickActions()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
          // الإحصائيات
          SliverToBoxAdapter(child: _buildStatsSection(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
          // الأهداف النشطة
          SliverToBoxAdapter(child: _buildGoalsSection(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
          // اليوميات الأخيرة
          SliverToBoxAdapter(child: _buildDiarySection(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          
          // سجل المزاج
          SliverToBoxAdapter(child: _buildMoodHistory(controller)),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildMoodSection(HomeController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF88C9A1), Color(0xFF5E81AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E81AC).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'كيف تشعر اليوم؟',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => controller.todayMood.value > 0
              ? _buildMoodDisplay(controller)
              : _buildMoodEmptyState(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodDisplay(HomeController controller) {
    final moodIndex = controller.todayMood.value - 1;
    final emoji = moodIndex >= 0 && moodIndex < AppConstants.moodEmojis.length
        ? AppConstants.moodEmojis[moodIndex]
        : '😐';
    final label = moodIndex >= 0 && moodIndex < AppConstants.moodLabels.length
        ? AppConstants.moodLabels[moodIndex]
        : 'محايد';

    return Column(
      children: [
        AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: 1.1,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 72),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          icon: Icons.edit,
          label: 'تحديث المزاج',
          onPressed: () => _showMoodDialog(Get.context!, controller),
          backgroundColor: Colors.white.withOpacity(0.25),
          foregroundColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildMoodEmptyState(HomeController controller) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mood,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        _buildGradientButton(
          icon: Icons.add,
          label: 'سجّل مزاجك الآن',
          onPressed: () => _showMoodDialog(Get.context!, controller),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF5E81AC),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'icon': Icons.psychology_outlined,
        'label': 'مساعد AI',
        'route': RoutesConfig.aiAssistant,
        'color': const Color(0xFFB48EAD),
        'gradient': const [Color(0xFFD8BFD8), Color(0xFFB48EAD)],
      },
      {
        'icon': Icons.warning_amber_outlined,
        'label': 'SOS',
        'route': RoutesConfig.sos,
        'color': const Color(0xFFBF616A),
        'gradient': const [Color(0xFFF0B3B3), Color(0xFFBF616A)],
      },
      {
        'icon': Icons.medication_outlined,
        'label': 'الأدوية',
        'route': RoutesConfig.medication,
        'color': const Color(0xFF81A1C1),
        'gradient': const [Color(0xFFB4C5D9), Color(0xFF81A1C1)],
      },
      {
        'icon': Icons.flag_outlined,
        'label': 'الأهداف',
        'route': RoutesConfig.goals,
        'color': const Color(0xFF88C9A1),
        'gradient': const [Color(0xFFB8E6C9), Color(0xFF88C9A1)],
      },
    ];

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: actions.map((action) {
              return _buildActionCard(
                icon: action['icon'] as IconData,
                label: action['label'] as String,
                gradient: action['gradient'] as List<Color>,
                onPressed: () => Get.toNamed(action['route'] as String),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(HomeController controller) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائياتك اليوم',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                icon: Icons.mood,
                label: 'متوسط المزاج',
                value: controller.averageMood.value > 0
                    ? controller.averageMood.value.toStringAsFixed(1)
                    : '-',
                color: Helpers.getMoodColor(controller.averageMood.value.toInt()),
              ),
              _buildStatCard(
                icon: Icons.book_outlined,
                label: 'اليوميات',
                value: controller.totalDiaryEntries.value.toString(),
                color: const Color(0xFF88C9A1),
              ),
              _buildStatCard(
                icon: Icons.flag_outlined,
                label: 'الأهداف',
                value: '${controller.completedGoalsCount.value}/${controller.totalGoalsCount.value}',
                color: const Color(0xFFB48EAD),
              ),
            ],
          )),
          const SizedBox(height: 24),
          // Progress bar للأهداف
          Obx(() {
            final percentage = controller.goalsCompletionPercentage;
            if (controller.totalGoalsCount.value == 0) return const SizedBox.shrink();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تقدم الأهداف',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5E81AC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFF0F2F5),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5E81AC)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أكمل ${controller.totalGoalsCount.value - controller.completedGoalsCount.value} هدف لوصولك لـ 100%',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalsSection(HomeController controller) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'أهدافك النشطة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(RoutesConfig.goals),
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF5E81AC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.activeGoals.isEmpty) {
              return _buildEmptyState(
                icon: Icons.flag_outlined,
                title: 'لا توجد أهداف نشطة',
                subtitle: 'ابدأ برحلة التعافي بإضافة هدف صغير اليوم',
                buttonText: 'إضافة هدف',
                onButtonPressed: () => Get.toNamed(RoutesConfig.goals),
              );
            }

            return Column(
              children: controller.activeGoals.take(3).map((goal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildGoalItem(goal),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalItem(GoalModel goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                goal.title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF88C9A1).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${goal.progress}%',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF88C9A1),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: goal.progress / 100,
            minHeight: 8,
            backgroundColor: const Color(0xFFF0F2F5),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF88C9A1)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'متبقي: ${_getRemainingDays(goal.targetDate)} يوم',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getRemainingDays(DateTime targetDate) {
    final today = DateTime.now();
    final difference = targetDate.difference(today).inDays;
    return difference > 0 ? difference.toString() : '0';
  }

  Widget _buildDiarySection(HomeController controller) {
    return Obx(() {
      if (controller.recentDiaryEntries.isEmpty) {
        return const SizedBox.shrink();
      }

      return CustomCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'يومياتك الأخيرة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(RoutesConfig.diary),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF5E81AC),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...controller.recentDiaryEntries.take(3).map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildDiaryItem(entry),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildDiaryItem(DiaryEntryModel entry) {
    final hasMood = entry.moodLevel != null && entry.moodLevel! > 0;
    final moodEmoji = hasMood && entry.moodLevel! <= AppConstants.moodEmojis.length
        ? AppConstants.moodEmojis[entry.moodLevel! - 1]
        : '';

    return GestureDetector(
      onTap: () => Get.toNamed(RoutesConfig.diaryDetail, arguments: entry),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4E7EB), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (hasMood) ...[
                  Text(moodEmoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    entry.title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5E81AC)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry.content,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  Helpers.formatDate(entry.createdAt),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                if (entry.tags != null && entry.tags!.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB48EAD).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry.tags!.first,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: const Color(0xFFB48EAD),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory(HomeController controller) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'سجل مزاجك',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(RoutesConfig.moodChart),
                child: const Text(
                  'عرض المخطط',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF5E81AC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.recentMoods.isEmpty) {
              return _buildEmptyState(
                icon: Icons.mood_outlined,
                title: 'لم تسجل مزاجك بعد',
                subtitle: 'ابدأ اليوم بتسجيل كيف تشعر لتتبع تقدمك',
                buttonText: 'تسجيل مزاجك',
                onButtonPressed: () => _showMoodDialog(Get.context!, controller),
              );
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.recentMoods.length,
                itemBuilder: (context, index) {
                  final mood = controller.recentMoods[index];
                  final moodIndex = mood.moodLevel - 1;
                  final emoji = moodIndex >= 0 && moodIndex < AppConstants.moodEmojis.length
                      ? AppConstants.moodEmojis[moodIndex]
                      : '😐';
                  
                  return Container(
                    width: 88,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Helpers.getMoodColor(mood.moodLevel).withOpacity(0.2),
                                Helpers.getMoodColor(mood.moodLevel).withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Helpers.getMoodColor(mood.moodLevel).withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Helpers.formatShortDate(mood.timestamp),
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF5E81AC).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: const Color(0xFF5E81AC)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildGradientButton(
              icon: Icons.add,
              label: buttonText,
              onPressed: onButtonPressed,
              backgroundColor: const Color(0xFF5E81AC),
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: foregroundColor),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(RoutesConfig.addDiary),
      icon: const Icon(Icons.add, size: 28),
      label: const Text(
        'يومية جديدة',
        style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
      ),
      backgroundColor: const Color(0xFF5E81AC),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
    );
  }

  void _showMoodDialog(BuildContext context, HomeController controller) {
    int selectedMood = controller.todayMood.value > 0 ? controller.todayMood.value : 5;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'كيف تشعر اليوم؟',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MoodSlider(
                  initialValue: selectedMood,
                  onChanged: (value) => selectedMood = value,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'ملاحظة (اختياري)',
                    labelStyle: const TextStyle(fontFamily: 'Cairo'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                  maxLines: 3,
                  style: const TextStyle(fontFamily: 'Cairo'),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.addMood(
                  selectedMood,
                  noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
                );
                Navigator.pop(context);
                Helpers.showSuccessSnackbar('تم تسجيل مزاجك بنجاح');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E81AC),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5E81AC)),
          ),
          SizedBox(height: 20),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}