// lib/features/teachers/presentation/screens/teacher_schedule_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/widgets/schedule_card.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_job/teacher_schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherScheduleScreen extends StatelessWidget {
  final User user;
  const TeacherScheduleScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return const _TeacherScheduleView();
  }
}

class _TeacherScheduleView extends StatelessWidget {
  const _TeacherScheduleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeacherScheduleCubit, TeacherScheduleState>(
        builder: (context, state) {
          if (state is TeacherScheduleLoading) {
            return const LoadingList(itemCount: 5, cardHeight: 120);
          }
          if (state is TeacherScheduleFailure) {
            return ErrorState(
              message: state.message,
              onRetry: () {
                final user =
                    context
                        .findAncestorWidgetOfExactType<TeacherScheduleScreen>()
                        ?.user;
                if (user != null) {
                  // ✨ --- التعديل الثاني هنا: تمرير اسم المستخدم عند إعادة المحاولة --- ✨
                  context.read<TeacherScheduleCubit>().fetchTeacherSchedule(
                    user.id,
                    user.name,
                  );
                }
              },
            );
          }
          if (state is TeacherScheduleSuccess) {
            if (state.schedule.isEmpty) {
              return const EmptyState(message: 'لا يوجد محاضرات في جدولك.');
            }
            return RefreshIndicator(
              onRefresh: () async {
                final user =
                    context
                        .findAncestorWidgetOfExactType<TeacherScheduleScreen>()
                        ?.user;
                if (user != null) {
                  // ✨ --- التعديل الثالث هنا: تمرير اسم المستخدم عند تحديث الصفحة --- ✨
                  context.read<TeacherScheduleCubit>().fetchTeacherSchedule(
                    user.id,
                    user.name,
                  );
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.schedule.length,
                itemBuilder: (context, index) {
                  final scheduleEntry = state.schedule[index];
                  // Using the shared schedule card widget
                  return ScheduleCard(entry: scheduleEntry);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
