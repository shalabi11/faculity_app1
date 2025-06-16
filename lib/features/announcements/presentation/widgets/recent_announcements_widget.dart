import 'package:faculity_app2/core/services/service_locator.dart';
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
            height: 150, // تحديد ارتفاع للـ ListView
            child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AnnouncementError) {
                  return Center(child: Text(state.message));
                }
                if (state is AnnouncementLoaded) {
                  if (state.announcements.isEmpty) {
                    return const Center(child: Text('لا توجد إعلانات حاليًا'));
                  }
                  // عرض أول 3 إعلانات فقط
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
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  announcement.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(),
                                Expanded(
                                  child: Text(
                                    announcement.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    announcement
                                        .createdAt, // سنقوم بتحسين شكل التاريخ لاحقًا
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
