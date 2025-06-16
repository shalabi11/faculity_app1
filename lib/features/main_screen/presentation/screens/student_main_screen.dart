import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/exams_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/home_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/profile_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/schedule_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/main_screen_cubit.dart';

class StudentMainScreen extends StatefulWidget {
  final User user; // <-- استقبال بيانات المستخدم
  const StudentMainScreen({super.key, required this.user});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // تهيئة قائمة الشاشات مع تمرير بيانات المستخدم
    _screens = [
      HomeScreen(user: widget.user),
      const ScheduleScreen(),
      const ExamsScreen(),
      const ProfileScreen(),
    ];
  }

  final List<String> _appBarTitles = const [
    'الرئيسية',
    'الجدول الدراسي',
    'الامتحانات والنتائج',
    'الملف الشخصي',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainScreenCubit(),
      child: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_appBarTitles[state.selectedIndex]),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            body: IndexedStack(index: state.selectedIndex, children: _screens),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<MainScreenCubit>().changeTab(index);
              },
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  label: 'الجدول',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_outlined),
                  label: 'الامتحانات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
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
