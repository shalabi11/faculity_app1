import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/main_screen_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/exams_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/home_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/profile_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/schedule_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentMainScreen extends StatefulWidget {
  final User user;
  const StudentMainScreen({super.key, required this.user});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen>
    with TickerProviderStateMixin {
  late final List<Widget> _screens;
  // TabControllers لكل شاشة تحتاجها
  late final TabController _scheduleTabController;
  late final TabController _examsTabController;

  @override
  void initState() {
    super.initState();
    _scheduleTabController = TabController(length: 2, vsync: this);
    _examsTabController = TabController(length: 2, vsync: this);

    _screens = [
      HomeScreen(user: widget.user),
      // تمرير الـ TabController إلى الشاشات الفرعية
      ScheduleScreen(user: widget.user, tabController: _scheduleTabController),
      ExamsScreen(user: widget.user, tabController: _examsTabController),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    _scheduleTabController.dispose();
    _examsTabController.dispose();
    super.dispose();
  }

  final List<String> _appBarTitles = const [
    'الرئيسية',
    'الجدول الدراسي',
    'الامتحانات والنتائج',
    'الملف الشخصي',
  ];

  // دالة لبناء الـ TabBar بناءً على الشاشة الحالية
  PreferredSizeWidget? _buildTabBar(int selectedIndex) {
    if (selectedIndex == 1) {
      // شاشة الجدول
      return TabBar(
        controller: _scheduleTabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        tabs: const [Tab(text: 'الجدول النظري'), Tab(text: 'الجدول العملي')],
      );
    } else if (selectedIndex == 2) {
      // شاشة الامتحانات
      return TabBar(
        controller: _examsTabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        tabs: const [Tab(text: 'جدول الامتحانات'), Tab(text: 'نتائجي')],
      );
    }
    return null; // لا يوجد TabBar للشاشات الأخرى
  }

  @override
  Widget build(BuildContext context) {
    // استخدام BlocProvider هنا لتوفير Cubit لإدارة حالة التنقل
    return BlocProvider(
      create: (context) => sl<MainScreenCubit>(),
      child: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_appBarTitles[state.selectedIndex]),
              // الـ bottom الآن ديناميكي
              bottom: _buildTabBar(state.selectedIndex),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
              ],
            ),
            body: IndexedStack(index: state.selectedIndex, children: _screens),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<MainScreenCubit>().changeTab(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'الجدول',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  activeIcon: Icon(Icons.bar_chart),
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
        },
      ),
    );
  }
}
