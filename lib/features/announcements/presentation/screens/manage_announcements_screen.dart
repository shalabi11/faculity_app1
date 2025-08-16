// lib/features/announcements/presentation/screens/manage_announcements_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/admin/presentation/screens/add_edit_announcement_screen.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/anage_announcements_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/manage_announcements_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManageAnnouncementsScreen extends StatelessWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

  void _refreshAnnouncements(BuildContext context) {
    context.read<AnnouncementCubit>().fetchAnnouncements();
  }

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
            _refreshAnnouncements(context);
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
            if (state is AnnouncementLoading || state is AnnouncementInitial) {
              return const _LoadingShimmerList();
            }
            if (state is AnnouncementError) {
              return ErrorState(
                message: state.message,
                onRetry: () => _refreshAnnouncements(context),
              );
            }
            if (state is AnnouncementLoaded) {
              if (state.announcements.isEmpty) {
                return const EmptyState(
                  message: 'لا توجد إعلانات لإدارتها. قم بإضافة إعلان جديد.',
                  icon: Icons.add_comment_outlined,
                );
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
            }
            return const SizedBox.shrink();
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

class _LoadingShimmerList extends StatelessWidget {
  const _LoadingShimmerList();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder:
            (context, index) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 20,
                    ),
                    const SizedBox(height: 12),
                    const ShimmerContainer(width: double.infinity, height: 14),
                    const SizedBox(height: 8),
                    ShimmerContainer(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
