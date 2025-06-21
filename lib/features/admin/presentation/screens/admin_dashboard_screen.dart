import 'package:faculity_app2/features/admin/presentation/screens/manage_announcements_screen.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardScreen extends StatelessWidget {
  final User user;
  const AdminDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // قائمة بخيارات الإدارة
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'إدارة الإعلانات',
        icon: Icons.campaign_outlined,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ManageAnnouncementsScreen(),
            ),
          );
        },
      ),
      DashboardItem(
        title: 'إدارة الطلاب',
        icon: Icons.people_outline,
        onTap: () {
          // TODO: Navigate to Manage Students Screen
        },
      ),
      DashboardItem(
        title: 'إدارة المدرسين',
        icon: Icons.school_outlined,
        onTap: () {
          // TODO: Navigate to Manage Teachers Screen
        },
      ),
      DashboardItem(
        title: 'إدارة المواد',
        icon: Icons.book_outlined,
        onTap: () {
          // TODO: Navigate to Manage Courses Screen
        },
      ),
      DashboardItem(
        title: 'إدارة الجداول',
        icon: Icons.calendar_today_outlined,
        onTap: () {
          // TODO: Navigate to Manage Schedules Screen
        },
      ),
      DashboardItem(
        title: 'إدارة الامتحانات',
        icon: Icons.event_note_outlined,
        onTap: () {
          // TODO: Navigate to Manage Exams Screen
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأدمن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // استخدام الـ AuthCubit العام لتسجيل الخروج
              context.read<AuthCubit>().loggedOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashView()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2, // نسبة العرض إلى الارتفاع للبطاقة
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _DashboardCard(item: item)
              .animate()
              .fade(delay: (100 * index).ms)
              .slideY(
                begin: 0.3,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              );
        },
      ),
    );
  }
}

// كلاس مساعد لتمثيل كل عنصر في لوحة التحكم
class DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardItem({required this.title, required this.icon, required this.onTap});
}

// ويدجت لعرض بطاقة الإدارة
class _DashboardCard extends StatelessWidget {
  final DashboardItem item;
  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
