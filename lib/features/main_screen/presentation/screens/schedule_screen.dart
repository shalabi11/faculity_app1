import 'package:faculity_app2/features/schedule/presentation/screens/manage_schedule_screen.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManageSchedulesScreen(
      appBar: AppBar(
        // title: const Text(' الجداول الدراسية'),
        // bottom: const TabBar(tabs: [Tab(text: 'نظري'), Tab(text: 'عملي')]),
      ),
    );
  }
}
