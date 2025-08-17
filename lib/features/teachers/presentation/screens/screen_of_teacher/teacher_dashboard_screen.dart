// lib/features/teachers/presentation/screens/screen_of_teacher/teacher_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_dashboard_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/widget/teacher_dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class TeacherDashboardScreen extends StatelessWidget {
  final User user;
  const TeacherDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              // الآن هذا الـ context يمكنه العثور على الـ Cubit بنجاح
              context.read<TeacherDashboardCubit>().fetchDashboardData(
                user.name,
              );
            },
            child: BlocBuilder<TeacherDashboardCubit, TeacherDashboardState>(
              builder: (context, state) {
                if (state is TeacherDashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TeacherDashboardFailure) {
                  return ErrorState(
                    message: state.message,
                    onRetry:
                        () => context
                            .read<TeacherDashboardCubit>()
                            .fetchDashboardData(user.name),
                  );
                }
                if (state is TeacherDashboardSuccess) {
                  return _buildBody(context, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TeacherDashboardSuccess state) {
    ScheduleEntity? nextLecture;
    if (state.schedule.isNotEmpty) {
      final now = DateTime.now();
      final todayDayName = DateFormat('EEEE', 'ar').format(now);

      final lecturesToday =
          state.schedule.where((s) => s.day == todayDayName).toList();
      lecturesToday.sort((a, b) => a.startTime.compareTo(b.startTime));

      nextLecture = lecturesToday.firstWhereOrNull((lec) {
        final startTimeParts = lec.startTime.split(':');
        final lectureTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(startTimeParts[0]),
          int.parse(startTimeParts[1]),
        );
        return lectureTime.isAfter(now);
      });

      if (nextLecture == null) {
        final allSortedLectures = List<ScheduleEntity>.from(state.schedule)
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        nextLecture = allSortedLectures.firstOrNull;
      }
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          children: [
            Expanded(
              child: KpiCard(
                title: 'إجمالي المقررات',
                value: state.courses.length.toString(),
                icon: Icons.book_outlined,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: KpiCard(
                title: 'محاضرة أسبوعياً',
                value: state.schedule.length.toString(),
                icon: Icons.calendar_today_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'الحدث القادم',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        UpcomingEventCard(exam: state.upcomingExam, nextLecture: nextLecture),
        const SizedBox(height: 24),
        const Text(
          'العبء الأسبوعي',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WeeklyWorkloadChart(schedule: state.schedule),
          ),
        ),
      ],
    );
  }
}
