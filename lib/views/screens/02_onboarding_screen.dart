import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../config/app_config.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.self_improvement,
      'title': 'اليقظة الذهنية',
      'description': 'تعلم مهارات اليقظة الذهنية للعيش في اللحظة الحالية',
    },
    {
      'icon': Icons.favorite,
      'title': 'تنظيم العواطف',
      'description': 'طور مهاراتك في إدارة المشاعر الصعبة',
    },
    {
      'icon': Icons.people,
      'title': 'علاقات صحية',
      'description': 'بناء والحفاظ على علاقات شخصية قوية',
    },
    {
      'icon': Icons.track_changes,
      'title': 'تتبع تقدمك',
      'description': 'راقب مزاجك وأهدافك بشكل يومي',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: _currentPage == _pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text('تخطي'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page['icon'],
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 48),
          Text(
            page['title'],
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page['description'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _finishOnboarding() async {
    final storage = Get.find<StorageService>();
    await storage.setBool(AppConfig.keyIsFirstTime, false);
    Get.offAllNamed(RoutesConfig.login);
  }
}