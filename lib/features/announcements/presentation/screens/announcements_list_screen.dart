// lib/features/announcements/presentation/screens/announcements_list_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class AnnouncementsListScreen extends StatelessWidget {
  const AnnouncementsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // توفير الـ Cubit لهذه الشاشة بشكل مستقل
    return BlocProvider(
      create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
      child: Scaffold(
        // appBar: AppBar(title: const Text('كل الإعلانات')),
        body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            // 1. حالة التحميل
            if (state is AnnouncementLoading || state is AnnouncementInitial) {
              return const LoadingList();
            }
            // 2. حالة الخطأ
            if (state is AnnouncementError) {
              return ErrorState(
                message: state.message,
                onRetry:
                    () =>
                        context.read<AnnouncementCubit>().fetchAnnouncements(),
              );
            }
            // 3. حالة النجاح
            if (state is AnnouncementLoaded) {
              if (state.announcements.isEmpty) {
                return const EmptyState(
                  message: 'لا توجد إعلانات لعرضها حالياً.',
                  icon: Icons.campaign_outlined,
                );
              }
              // عرض القائمة الكاملة
              return RefreshIndicator(
                onRefresh:
                    () async =>
                        context.read<AnnouncementCubit>().fetchAnnouncements(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = state.announcements[index];
                    return _AnnouncementCard(announcement: announcement)
                        .animate()
                        .fade(delay: (100 * index).ms)
                        .slideY(begin: 0.3);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// بطاقة عرض الإعلان بتصميم احترافي
class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              announcement.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.userName ?? 'غير معروف',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                // --- التصحيح النهائي هنا ---
                // استخدام DateFormat لتحويل التاريخ إلى نص منسق
                Text(
                  DateFormat('yyyy/MM/d', 'ar').format(announcement.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
