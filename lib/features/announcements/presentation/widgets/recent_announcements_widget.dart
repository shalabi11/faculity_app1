import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/announcement_cubit.dart';

class RecentAnnouncementsWidget extends StatelessWidget {
  const RecentAnnouncementsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'آخر الإعلانات',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
              builder: (context, state) {
                // --- حالة التحميل الجديدة ---
                if (state is AnnouncementLoading) {
                  return const _AnnouncementsLoadingWidget();
                }
                if (state is AnnouncementError) {
                  return Center(child: Text(state.message));
                }
                if (state is AnnouncementLoaded) {
                  if (state.announcements.isEmpty) {
                    return const Center(child: Text('لا توجد إعلانات حاليًا'));
                  }
                  final recentAnnouncements =
                      state.announcements.take(3).toList();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentAnnouncements.length,
                    itemBuilder: (context, index) {
                      final announcement = recentAnnouncements[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Card(
                          // ... الكود كما هو
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ويدجت حالة التحميل باستخدام Shimmer
class _AnnouncementsLoadingWidget extends StatelessWidget {
  const _AnnouncementsLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2, // عرض بطاقتي تحميل
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerContainer(width: 150, height: 16),
                    const Divider(),
                    const ShimmerContainer(width: double.infinity, height: 12),
                    const SizedBox(height: 8),
                    const ShimmerContainer(width: 200, height: 12),
                    const Spacer(),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: ShimmerContainer(width: 80, height: 10),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
