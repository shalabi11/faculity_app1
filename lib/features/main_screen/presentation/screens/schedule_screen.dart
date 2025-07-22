// lib/features/main_screen/presentation/screens/schedule_screen.dart

import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/presentation/widgets/schedule_list_view.dart';
import 'package:flutter/material.dart';

// الحفاظ على اسم الكلاس الأصلي
class ScheduleScreen extends StatefulWidget {
  final User user;
  const ScheduleScreen({super.key, required this.user});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // هذا التصحيح ضروري لعمل التبويبات
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
          tabs: const [Tab(text: 'الجدول النظري'), Tab(text: 'الجدول العملي')],
        ),
        // المحتوى الذي يتغير مع كل تبويب
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // التبويب الأول: يعرض جدول المواد النظرية
              ScheduleListView(scheduleType: 'theory', year: widget.user.year),

              // التبويب الثاني: يعرض جدول المواد العملية
              ScheduleListView(
                scheduleType: 'lab',
                section: widget.user.section,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
