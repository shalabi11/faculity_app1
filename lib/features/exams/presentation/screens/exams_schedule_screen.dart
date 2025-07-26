// lib/features/exams/presentation/screens/exams_schedule_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';

import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class ExamsScheduleScreen extends StatelessWidget {
  final User user;
  const ExamsScheduleScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExamCubit>()..fetchExams(),
      child: const _ExamsScheduleView(),
    );
  }
}

class _ExamsScheduleView extends StatelessWidget {
  const _ExamsScheduleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExamCubit, ExamState>(
        builder: (context, state) {
          if (state is ExamLoading) {
            return const LoadingList();
          }
          if (state is ExamError) {
            return ErrorState(
              message: state.message,
              onRetry: () => context.read<ExamCubit>().fetchExams(),
            );
          }
          if (state is ExamLoaded) {
            if (state.exams.isEmpty) {
              return const EmptyState(
                message: 'لا توجد امتحانات مجدولة حالياً.',
                icon: Icons.event_busy_outlined,
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<ExamCubit>().fetchExams(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.exams.length,
                itemBuilder: (context, index) {
                  final ExamEntity exam = state.exams[index];
                  return _ExamCard(
                    exam: exam,
                  ).animate().fade(delay: (100 * index).ms).slideY(begin: 0.3);
                },
              ),
            );
          }
          return const LoadingList();
        },
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamEntity exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    try {
      // --- التصحيح هنا: تحويل النص إلى تاريخ ---
      final DateTime examDateTime = exam.examDate as DateTime;

      // ثم استخدام الكائن الجديد في التنسيق
      final String displayDate = DateFormat(
        'd MMMM',
        'ar',
      ).format(examDateTime);
      final String dayName = DateFormat('EEEE', 'ar').format(examDateTime);

      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      displayDate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.courseName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      text: 'الوقت: ${exam.startTime} - ${exam.endTime}',
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.bookmark_border_rounded,
                      text: 'النوع: ${exam.type}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // في حال كان صيغة النص غير صحيحة، نعرض التاريخ كما هو لتجنب انهيار التطبيق
      return Card(
        child: ListTile(
          title: Text(exam.courseName),
          subtitle: Text("تاريخ غير صالح: ${exam.examDate}"),
        ),
      );
    }
  }
}

// ... باقي الكود (_InfoRow) يبقى كما هو ...
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
