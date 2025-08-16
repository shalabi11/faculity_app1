// lib/features/exams/presentation/screens/student_results_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:faculity_app2/core/theme/app_color.dart';

class StudentResultsScreen extends StatelessWidget {
  final User user;
  const StudentResultsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              di.sl<StudentExamResultsCubit>()
                ..fetchStudentResults(studentId: user.id),
      child: const _StudentResultsView(),
    );
  }
}

class _StudentResultsView extends StatelessWidget {
  const _StudentResultsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentExamResultsCubit, StudentExamResultsState>(
        builder: (context, state) {
          if (state is StudentExamResultsLoading) {
            return const LoadingList(itemCount: 6, cardHeight: 80);
          }
          if (state is StudentExamResultsFailure) {
            return ErrorState(
              message: state.message,
              onRetry: () {
                final user =
                    context
                        .findAncestorWidgetOfExactType<StudentResultsScreen>()
                        ?.user;
                if (user != null) {
                  context.read<StudentExamResultsCubit>().fetchStudentResults(
                    studentId: user.id,
                  );
                }
              },
            );
          }
          if (state is StudentExamResultsSuccess) {
            if (state.results.isEmpty) {
              return const EmptyState(
                message: 'لم تصدر أي نتائج بعد.',
                icon: Icons.school_outlined,
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final user =
                    context
                        .findAncestorWidgetOfExactType<StudentResultsScreen>()
                        ?.user;
                if (user != null) {
                  context.read<StudentExamResultsCubit>().fetchStudentResults(
                    studentId: user.id,
                  );
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return _ResultCard(
                    result: result,
                  ).animate().fade(delay: (100 * index).ms).slideY(begin: 0.3);
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

class _ResultCard extends StatelessWidget {
  final ExamResultEntity result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = (result.score ?? 0) >= 60;
    final Color color = isSuccess ? AppColors.success : AppColors.error;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          isSuccess ? Icons.check_circle_outline : Icons.highlight_off,
          color: color,
          size: 32,
        ),
        title: Text(
          result.courseName,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          result.score?.toStringAsFixed(1) ?? 'N/A',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
