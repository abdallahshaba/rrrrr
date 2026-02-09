import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/utils/helpers.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:dbt_mental_health_app/views/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/diary_controller.dart';


class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DiaryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('يومياتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.entries.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.book,
            title: 'لا توجد مدخلات',
            message: 'ابدأ بكتابة أول يومية لك',
            buttonText: 'إضافة يومية',
            onButtonPressed: () => Get.toNamed(RoutesConfig.addDiary),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadEntries,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.entries.length,
            itemBuilder: (context, index) {
              final entry = controller.entries[index];
              return CustomCard(
                onTap: () => Get.toNamed(
                  RoutesConfig.diaryDetail,
                  arguments: entry,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showOptionsMenu(context, controller, entry),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDate(entry.createdAt),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        if (entry.moodLevel != null) ...[
                          const SizedBox(width: 16),
                          Icon(Icons.mood, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${entry.moodLevel}/10',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RoutesConfig.addDiary),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, DiaryController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('بحث في اليوميات'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'ابحث...'),
          onChanged: (query) {
            controller.searchEntries(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.loadEntries();
              Get.back();
            },
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, DiaryController controller, entry) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل'),
              onTap: () {
                Get.back();
                Get.toNamed(RoutesConfig.editDiary, arguments: entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Get.back();
                final confirm = await Helpers.showConfirmDialog(
                  title: 'تأكيد الحذف',
                  message: 'هل أنت متأكد من حذف هذه اليومية؟',
                );
                if (confirm) {
                  await controller.deleteEntry(entry.id!);
                  Helpers.showSuccessSnackbar('تم حذف اليومية');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}