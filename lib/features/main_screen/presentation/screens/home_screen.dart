import 'package:faculity_app2/features/announcements/presentation/widgets/recent_announcements_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final User user; // <-- استقبال بيانات المستخدم
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام ListView يسمح بالتمرير إذا زاد المحتوى
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // 1. قسم رسالة الترحيب
          _WelcomeWidget(userName: user.name),
          const SizedBox(height: 30),

          // 2. قسم الإعلانات (الذي أنشأناه سابقًا)
          const RecentAnnouncementsWidget(),
          const SizedBox(height: 30),

          // 3. قسم جدول اليوم (سنبنيه في الخطوة التالية)
          // const _TodaysScheduleWidget(),
        ],
      ),
    );
  }
}

// ويدجت داخلي ومنفصل لرسالة الترحيب
class _WelcomeWidget extends StatelessWidget {
  final String userName;
  const _WelcomeWidget({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أهلاً بك مجددًا،',
            style: TextStyle(fontSize: 22, color: Colors.grey.shade700),
          ),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
