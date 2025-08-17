// lib/features/main_screen/presentation/screens/student_main_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد الشاشات
import 'home_screen.dart';
import 'schedule_screen.dart';
import 'exams_screen.dart';
import 'profile_screen.dart';

class StudentMainScreen extends StatelessWidget {
  final User user;
  const StudentMainScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            // ✨ --- هذا هو الجزء الذي تم تعديله --- ✨
            final cubit = di.sl<ScheduleCubit>();
            // إضافة تأخير بسيط جداً قبل أول طلب للبيانات
            Future.delayed(const Duration(milliseconds: 200), () {
              if (!cubit.isClosed) {
                cubit.fetchStudentWeeklySchedule(
                  year: user.year,
                  section: user.section,
                );
              }
            });
            return cubit;
          },
        ),
        BlocProvider(
          create:
              (context) =>
                  sl<StudentExamResultsCubit>()
                    ..fetchStudentResults(studentId: user.id),
        ),
        BlocProvider(
          create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
        ),
        BlocProvider(create: (context) => sl<ExamCubit>()..fetchExams()),
      ],
      child: _StudentMainScreenView(user: user),
    );
  }
}

class _StudentMainScreenView extends StatefulWidget {
  final User user;
  const _StudentMainScreenView({required this.user});

  @override
  State<_StudentMainScreenView> createState() => _StudentMainScreenViewState();
}

class _StudentMainScreenViewState extends State<_StudentMainScreenView> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  final List<String> _appBarTitles = const [
    'الرئيسية',
    'الجدول الدراسي',
    'الامتحانات والنتائج',
    'الملف الشخصي',
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
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
