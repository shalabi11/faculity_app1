// lib/features/teachers/presentation/screens/teacher_dashboard_screen.dart

import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final User user;
  const TeacherDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // يمكنك هنا إضافة Cubits لجلب بيانات اليوم (المحاضرات، إلخ)
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // يمكنك إضافة ويدجت لعرض المحاضرات القادمة اليوم
        // أو إحصائيات سريعة عن عدد المقررات والطلاب
        Card(
          child: ListTile(
            leading: Icon(
              Icons.schedule,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text('محاضرات اليوم'),
            subtitle: const Text('لا توجد محاضرات مجدولة لهذا اليوم.'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // يمكنك الانتقال إلى شاشة الجدول الكامل
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.book, color: Theme.of(context).primaryColor),
            title: const Text('المقررات الدراسية'),
            subtitle: const Text('أنت تدرّس X مقررات هذا الفصل.'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // يمكنك الانتقال إلى شاشة المقررات
            },
          ),
        ),
      ],
    );
  }
}
