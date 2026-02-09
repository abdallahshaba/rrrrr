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
    final entry = Get.arguments as DiaryEntryModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل اليومية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(RoutesConfig.editDiary, arguments: entry),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  Helpers.formatDateTime(entry.createdAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (entry.updatedAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.edit, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'عُدّل ${Helpers.getTimeAgo(entry.updatedAt!)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            if (entry.moodLevel != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Helpers.getMoodColor(entry.moodLevel!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      AppConstants.moodEmojis[entry.moodLevel! - 1],
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('المزاج', style: TextStyle(fontSize: 12)),
                        Text(
                          AppConstants.moodLabels[entry.moodLevel! - 1],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              entry.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            if (entry.tags != null && entry.tags!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'الوسوم',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: entry.tags!.map((tag) {
                  return Chip(label: Text(tag));
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}