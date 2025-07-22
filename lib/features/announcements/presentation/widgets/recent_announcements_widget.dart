// lib/features/announcements/presentation/widgets/recent_announcements_widget.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RecentAnnouncementsWidget extends StatelessWidget {
  const RecentAnnouncementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استخدام BlocProvider لتوفير الـ Cubit وطلب البيانات فوراً
    return BlocProvider(
      create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
      child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
        builder: (context, state) {
          // 2. معالجة حالة التحميل
          if (state is AnnouncementLoading) {
            // استخدام نسخة مصغرة من واجهة التحميل
            return const LoadingList(itemCount: 3, cardHeight: 80);
          }
          // 3. معالجة حالة الخطأ
          if (state is AnnouncementError) {
            return Center(
              child: Text('خطأ في تحميل الإعلانات: ${state.message}'),
            );
          }
          // 4. معالجة حالة النجاح
          if (state is AnnouncementLoaded) {
            // 4.1 إذا كانت القائمة فارغة
            if (state.announcements.isEmpty) {
              return const EmptyState(
                message: "لا توجد إعلانات لعرضها.",
                icon: Icons.campaign_outlined,
              );
            }

            // 4.2 عرض الإعلانات
            // نأخذ آخر 3 إعلانات فقط باستخدام .take()
            final recentAnnouncements = state.announcements.take(3).toList();

            return Column(
              children: List.generate(
                recentAnnouncements.length,
                (index) =>
                    _AnnouncementTile(announcement: recentAnnouncements[index]),
              ),
            );
          }
          // الحالة الافتراضية
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ويدجت لعرض الإعلان الواحد بتصميم نظيف
class _AnnouncementTile extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.campaign_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          announcement.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          announcement.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          DateFormat('d MMM', 'ar').format(announcement.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {
          // TODO: إضافة الانتقال إلى شاشة تفاصيل الإعلان
        },
      ),
    );
  }
}
