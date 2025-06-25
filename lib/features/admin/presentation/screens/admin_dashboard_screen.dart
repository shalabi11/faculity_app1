// lib/features/admin/presentation/screens/admin_dashboard_screen.dart

import 'package:faculity_app2/features/admin/presentation/screens/add_edit_announcement_screen.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_profile_screen.dart'; // <-- أضف هذا السطر
import 'package:faculity_app2/features/admin/presentation/screens/manage_announcements_screen.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';

import 'package:faculity_app2/features/classrooms/presentation/screens/manage_classrooms_screen.dart';
import 'package:faculity_app2/features/courses/presentation/screens/manage_course_screen.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/screens/distribute_halls_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/manage_exams_screen.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/manage_schedule_screen.dart';
import 'package:faculity_app2/features/student/presentation/screens/mange_student_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/manage_teachers_screen.dart';
import 'package:faculity_app2/features/users/presentation/screens/manage_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key, required User user});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'إدارة الطلاب',
        icon: Icons.people_outline,
        onTap: () => _navigateTo(context, const ManageStudentsScreen()),
      ),
      DashboardItem(
        title: 'إدارة المدرسين',
        icon: Icons.school_outlined,
        onTap: () => _navigateTo(context, const ManageTeachersScreen()),
      ),
      DashboardItem(
        title: 'إدارة المواد',
        icon: Icons.book_outlined,
        onTap: () => _navigateTo(context, const ManageCoursesScreen()),
      ),
      DashboardItem(
        title: 'إدارة القاعات',
        icon: Icons.meeting_room_outlined,
        onTap: () => _navigateTo(context, const ManageClassroomsScreen()),
      ),
      DashboardItem(
        title: 'إدارة الجداول',
        icon: Icons.schedule_outlined,
        onTap: () => _navigateTo(context, const ManageSchedulesScreen()),
      ),
      DashboardItem(
        title: 'إدارة الامتحانات',
        icon: Icons.assignment_outlined,
        onTap: () => _navigateTo(context, const ManageExamsScreen()),
      ),
      DashboardItem(
        title: 'إدارة الإعلانات',
        icon: Icons.campaign_outlined,
        onTap: () => _navigateTo(context, const ManageAnnouncementsScreen()),
      ),
      DashboardItem(
        title: 'توزيع القاعات',
        icon: Icons.grid_on_outlined,
        onTap: () {
          _navigateTo(context, const DistributeHallsScreen());
        },
      ),
      // DashboardItem(
      //   title: 'إدارة المستخدمين',
      //   icon: Icons.supervised_user_circle_outlined,
      //   onTap: () {
      //     Navigator.of(
      //       context,
      //     ).push(MaterialPageRoute(builder: (_) => const ManageUsersScreen()));
      //   },
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المسؤول'),
        automaticallyImplyLeading: false,
        // --- التعديل هنا: إضافة زر الملف الشخصي ---
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return DashboardCard(item: item);
            },
          )
          .animate(delay: 100.ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeInOut),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.item});

  final DashboardItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardItem({required this.title, required this.icon, required this.onTap});
}
