// lib/features/main_screen/presentation/screens/student_main_screen.dart

import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// استيراد الشاشات مع الحفاظ على أسمائها الأصلية
import 'home_screen.dart';
import 'schedule_screen.dart';
import 'exams_screen.dart';
import 'profile_screen.dart';

// تم تحويل الويدجت إلى StatefulWidget لإدارة حالته الداخلية (الصفحة المختارة)
// هذا التغيير ضروري لتحقيق التنقل السلس دون التأثير على منطق الكود في أي مكان آخر
class StudentMainScreen extends StatefulWidget {
  final User user;
  const StudentMainScreen({super.key, required this.user});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  // Controller للتحكم في الصفحات
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // قائمة الشاشات بنفس أسمائها
  late final List<Widget> _screens;

  // قائمة العناوين
  final List<String> _appBarTitles = const [
    'الرئيسية',
    'الجدول الدراسي',
    'الامتحانات والنتائج',
    'الملف الشخصي',
  ];

  @override
  void initState() {
    super.initState();
    // بناء قائمة الشاشات وتمرير بيانات المستخدم
    _screens = [
      // HomeScreen(user: widget.user),
      ScheduleScreen(user: widget.user),
      ExamsScreen(user: widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // دالة لتغيير الصفحة عند الضغط على شريط التنقل
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
            onPressed: () {
              // يمكنك إضافة وظيفة هنا لاحقاً
            },
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
            label: 'الامتحانات',
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
