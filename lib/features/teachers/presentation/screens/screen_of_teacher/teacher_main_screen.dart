// lib/features/teachers/presentation/screens/teacher_main_screen.dart

import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_announcements_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_courses_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_dashboard_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_profile_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TeacherMainScreen extends StatefulWidget {
  final User user;
  const TeacherMainScreen({super.key, required this.user});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  final List<String> _appBarTitles = const [
    'الرئيسية',
    'الجدول الدراسي',
    'المقررات',
    'الإعلانات',
    'الملف الشخصي',
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      TeacherDashboardScreen(user: widget.user),
      TeacherScheduleScreen(user: widget.user),
      TeacherCoursesScreen(user: widget.user),
      TeacherAnnouncementsScreen(user: widget.user),
      TeacherProfileScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ).animate().fade().slideX(),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_filled),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'الجدول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'المقررات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_outlined),
            activeIcon: Icon(Icons.campaign),
            label: 'الإعلانات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
