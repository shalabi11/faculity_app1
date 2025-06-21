import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/admin/presentation/screens/add_edit_announcement_screen.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/anage_announcements_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/manage_announcements_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManageAnnouncementsScreen extends StatelessWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // توفير الـ Cubits اللازمة لهذه الشاشة
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
        ),
        BlocProvider(create: (context) => sl<ManageAnnouncementsCubit>()),
      ],
      child: const _ManageAnnouncementsView(),
    );
  }
}

class _ManageAnnouncementsView extends StatelessWidget {
  const _ManageAnnouncementsView();

  // دالة لتحديث قائمة الإعلانات
  void _refreshAnnouncements(BuildContext context) {
    context.read<AnnouncementCubit>().fetchAnnouncements();
  }

  // دالة لعرض حوار تأكيد الحذف
  void _showDeleteConfirmationDialog(
    BuildContext context,
    Announcement announcement,
  ) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف الإعلان "${announcement.title}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<ManageAnnouncementsCubit>().deleteAnnouncement(
                    id: announcement.id,
                  );
                },
                child: const Text(
                  'حذف',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الإعلانات')),
      body: BlocListener<ManageAnnouncementsCubit, ManageAnnouncementsState>(
        listener: (context, state) {
          if (state is ManageAnnouncementsSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            _refreshAnnouncements(context); // تحديث القائمة بعد النجاح
          }
          if (state is ManageAnnouncementsFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
          }
        },
        child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementLoading && state.announcements.isEmpty) {
              return const _LoadingList();
            }
            if (state is AnnouncementError) {
              return Center(child: Text(state.message));
            }
            if (state.announcements.isEmpty) {
              return const Center(child: Text('لا توجد إعلانات لعرضها.'));
            }
            return RefreshIndicator(
              onRefresh: () async => _refreshAnnouncements(context),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.announcements.length,
                itemBuilder: (context, index) {
                  final announcement = state.announcements[index];
                  return _AnnouncementManagementCard(
                    announcement: announcement,
                    onDelete:
                        () => _showDeleteConfirmationDialog(
                          context,
                          announcement,
                        ),
                    onEdit: () async {
                      final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder:
                              (_) => AddEditAnnouncementScreen(
                                announcement: announcement,
                              ),
                        ),
                      );
                      if (result == true) {
                        _refreshAnnouncements(context);
                      }
                    },
                  );
                },
              ).animate().fade(duration: 400.ms),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const AddEditAnnouncementScreen(),
            ),
          );
          if (result == true) {
            _refreshAnnouncements(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// بطاقة الإعلان مع أزرار التحكم
class _AnnouncementManagementCard extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnnouncementManagementCard({
    required this.announcement,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
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
          return const Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(height: 18, width: 200),
                  SizedBox(height: 12),
                  ShimmerContainer(height: 14),
                  SizedBox(height: 8),
                  ShimmerContainer(height: 14, width: 250),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
