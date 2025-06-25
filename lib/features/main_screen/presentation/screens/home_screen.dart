import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/announcements/presentation/widgets/recent_announcements_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/home_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/home_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../schedule/domain/entities/schedule_entry.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // 1. قسم رسالة الترحيب
          _WelcomeWidget(userName: user.name)
              .animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),

          const SizedBox(height: 30),

          // 2. قسم الإعلانات (الذي أنشأناه سابقًا)
          const RecentAnnouncementsWidget()
              .animate()
              .fade(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),

          const SizedBox(height: 30),

          // 3. قسم جدول اليوم
          _TodaysScheduleWidget(user: user)
              .animate()
              .fade(delay: 400.ms, duration: 400.ms)
              .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}

// ===============================================
//  ويدجت الترحيب
// ===============================================
class _WelcomeWidget extends StatelessWidget {
  final String userName;
  const _WelcomeWidget({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أهلاً بك مجددًا،',
            style: TextStyle(fontSize: 22, color: Colors.grey.shade700),
          ),
          Text(
            userName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================
//  ويدجت جدول اليوم
// ===============================================
class _TodaysScheduleWidget extends StatelessWidget {
  final User user;
  const _TodaysScheduleWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<HomeCubit>()
                ..fetchTodaysSchedule(year: user.year, group: user.section),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'جدول اليوم',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is TodaysScheduleLoading) {
                  return const _ScheduleLoadingWidget();
                }
                if (state is TodaysScheduleError) {
                  return Center(child: Text(state.message));
                }
                if (state is TodaysScheduleLoaded) {
                  if (state.entries.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('لا يوجد محاضرات اليوم، استمتع بيومك!'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.entries.length,
                    itemBuilder: (context, index) {
                      final entry = state.entries[index];
                      return _ScheduleEntryTile(entry: entry)
                          .animate()
                          .fade(delay: (100 * index).ms, duration: 300.ms)
                          .slideX(begin: 0.2, duration: 300.ms);
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

// ===============================================
//  ويدجت حالة تحميل جدول اليوم
// ===============================================
class _ScheduleLoadingWidget extends StatelessWidget {
  const _ScheduleLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const ShimmerContainer(
                width: 48,
                height: 48,
                borderRadius: 24,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerContainer(
                    width: 150,
                    height: 14,
                    borderRadius: 24,
                  ),
                  const SizedBox(height: 5),
                  const ShimmerContainer(
                    width: 100,
                    height: 12,
                    borderRadius: 24,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===============================================
//  ويدجت عرض محاضرة واحدة
// ===============================================
class _ScheduleEntryTile extends StatelessWidget {
  final ScheduleEntry entry;
  const _ScheduleEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            entry.startTime.split(':').first,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Text(
          entry.courseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${entry.teacherName} - ${entry.classroomName}"),
        trailing: Text(
          '${entry.startTime} - ${entry.endTime}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
