import 'package:flutter/material.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/schedule_screen.dart';

class ScheduleManagementScreen extends StatelessWidget {
  final String year; // السنة التي تم اختيارها من الشاشة السابقة

  const ScheduleManagementScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    // استخدام DefaultTabController لتنظيم الواجهة
    return DefaultTabController(
      length: 2, // عدد الأقسام (نظري وعملي)
      child: Scaffold(
        appBar: AppBar(
          title: Text('جدول السنة $year'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'البرنامج النظري', icon: Icon(Icons.class_outlined)),
              Tab(text: 'البرنامج العملي', icon: Icon(Icons.biotech_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // الواجهة الخاصة بالبرنامج النظري
            // يتم تمرير السنة الدراسية لجلب الجدول الخاص بها
            ScheduleScreen(scheduleType: 'theory', identifier: year),

            // الواجهة الخاصة بالبرنامج العملي
            // ملاحظة: يمكن لاحقاً إضافة واجهة لاختيار الشعبة والفرقة
            ScheduleScreen(
              scheduleType: 'lab',
              identifier: 'A', // كمثال، الشعبة A
              section: 'B', // كمثال، الفرقة B
            ),
          ],
        ),
      ),
    );
  }
}
