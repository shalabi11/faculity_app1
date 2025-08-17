// lib/features/teachers/presentation/screens/teacher_announcements_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/admin/presentation/screens/add_edit_announcement_screen.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/screens/announcements_list_screen.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAnnouncementsScreen extends StatelessWidget {
  final User user;
  const TeacherAnnouncementsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // ✨ ---  تم تعديل الواجهة بالكامل هنا --- ✨
    // ببساطة، سنقوم بإعادة استخدام نفس شاشة عرض الإعلانات الكاملة
    // التي يستخدمها الطالب والمدير، لأنها تحتوي على كل المنطق المطلوب.
    return Scaffold(
      // استخدام AnnouncementsListScreen مباشرة يعيد استخدام الكود ويمنع التكرار
      body: const AnnouncementsListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // عند الضغط، ننتقل إلى شاشة إضافة إعلان جديد
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => const AddEditAnnouncementScreen(),
                ),
              )
              .then((success) {
                // إذا تمت الإضافة بنجاح (رجعت true)، نقوم بتحديث القائمة
                if (success == true) {
                  context.read<AnnouncementCubit>().fetchAnnouncements();
                }
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
