import 'package:flutter/material.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';

class GratitudeJournalScreen extends StatefulWidget {
  const GratitudeJournalScreen({super.key});

  @override
  State<GratitudeJournalScreen> createState() => _GratitudeJournalScreenState();
}

class _GratitudeJournalScreenState extends State<GratitudeJournalScreen> {
  final List<String> gratitudes = [];
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('يومية الامتنان'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'لماذا الامتنان؟',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'ممارسة الامتنان يومياً تساعد على:\n'
                  '• تحسين المزاج والسعادة\n'
                  '• تقليل التوتر والقلق\n'
                  '• تعزيز العلاقات الإيجابية\n'
                  '• زيادة تقدير الذات\n'
                  '• النوم بشكل أفضل',
                  style: TextStyle(color: Colors.grey[700], height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ما الذي تشعر بالامتنان له اليوم؟',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'اكتب شيئاً تشعر بالامتنان له...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'إضافة',
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        gratitudes.insert(0, _controller.text);
                        _controller.clear();
                      });
                    }
                  },
                  icon: Icons.add,
                ),
              ],
            ),
          ),
          if (gratitudes.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'قائمة الامتنان',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...gratitudes.map((gratitude) => CustomCard(
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink),
                  const SizedBox(width: 16),
                  Expanded(child: Text(gratitude)),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        gratitudes.remove(gratitude);
                      });
                    },
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}