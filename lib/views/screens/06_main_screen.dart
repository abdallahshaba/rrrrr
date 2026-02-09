import 'package:dbt_mental_health_app/views/screens/07_home_screen.dart';
import 'package:dbt_mental_health_app/views/screens/09_diary_screen.dart';
import 'package:dbt_mental_health_app/views/screens/13_skills_library_screen.dart';
import 'package:dbt_mental_health_app/views/screens/25_reports_screen.dart';
import 'package:dbt_mental_health_app/views/screens/30_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/sos_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiaryScreen(),
    const SkillsLibraryScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
            tooltip: 'Cairo'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'اليوميات',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'المهارات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'التقارير',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
      floatingActionButton: const SOSButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}