// lib/features/main_screen/presentation/screens/exams_screen.dart

import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exam_result_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exams_schedule_screen.dart';
import 'package:flutter/material.dart';

// الحفاظ على اسم الكلاس الأصلي
class ExamsScreen extends StatefulWidget {
  final User user;
  const ExamsScreen({super.key, required this.user});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // إدارة الـ TabController داخل الشاشة نفسها
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // واجهة التبويبات العلوية
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'جدول الامتحانات'),
            Tab(text: 'النتائج الامتحانية'),
          ],
        ),
        // المحتوى الذي يتغير مع كل تبويب
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // التبويب الأول: يعرض شاشة جدول الامتحانات
              ExamsScheduleScreen(user: widget.user),

              // التبويب الثاني: يعرض شاشة نتائج الامتحانات
              ExamSelectionForResultsScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
