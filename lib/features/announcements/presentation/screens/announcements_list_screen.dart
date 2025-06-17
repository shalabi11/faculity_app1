import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:faculity_app2/features/announcements/presentation/screens/announcement_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnnouncementsListScreen extends StatelessWidget {
  const AnnouncementsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
      child: Scaffold(
        appBar: AppBar(title: const Text('كل الإعلانات')),
        body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            // عرض التحميل فقط في المرة الأولى
            if (state is AnnouncementLoading && state.announcements.isEmpty) {
              return const _LoadingList();
            }
            if (state is AnnouncementError) {
              return Center(child: Text(state.message));
            }
            if (state is AnnouncementLoaded) {
              if (state.announcements.isEmpty) {
                return const Center(child: Text('لا توجد إعلانات لعرضها.'));
              }
              // إضافة التحديث بالسحب
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<AnnouncementCubit>().fetchAnnouncements();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.announcements.length,
                  itemBuilder: (context, index) {
                    final announcement = state.announcements[index];
                    return _AnnouncementCard(announcement: announcement);
                  },
                ).animate().fade(duration: 400.ms),
              );
            }
            // في الحالات الأخرى (مثل بعد التحديث)، استمر في عرض البيانات القديمة أثناء التحميل في الخلفية
            return const _LoadingList();
          },
        ),
      ),
    );
  }
}

// ويدجت لعرض بطاقة الإعلان
class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => AnnouncementDetailScreen(announcement: announcement),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                announcement.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                announcement.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    announcement.createdAt,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجت حالة التحميل
class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerContainer(height: 18, width: 200),
                  const SizedBox(height: 12),
                  const ShimmerContainer(height: 14),
                  const SizedBox(height: 8),
                  const ShimmerContainer(height: 14, width: 250),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
