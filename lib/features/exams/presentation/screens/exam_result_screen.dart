// lib/features/exams/presentation/screens/exam_result_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExamResultScreen extends StatelessWidget {
  final User user;
  const ExamResultScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<StudentExamResultsCubit>()
                ..fetchStudentResults(studentId: user.id),
      // --- تمرير كائن user إلى الـ View ---
      child: _ExamResultView(user: user),
    );
  }
}

class _ExamResultView extends StatelessWidget {
  // --- استقبال كائن user هنا ---
  final User user;
  const _ExamResultView({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentExamResultsCubit, StudentExamResultsState>(
        builder: (context, state) {
          if (state is StudentExamResultsLoading) {
            return const LoadingList();
          }
          if (state is StudentExamResultsFailure) {
            return ErrorState(
              message: state.message,
              // --- تصحيح: استخدام user.id مباشرة ---
              onRetry: () {
                context.read<StudentExamResultsCubit>().fetchStudentResults(
                  studentId: user.id,
                );
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
              // --- تصحيح: استخدام user.id مباشرة ---
              onRefresh: () async {
                context.read<StudentExamResultsCubit>().fetchStudentResults(
                  studentId: user.id,
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final ExamResult result = state.results[index];
                  return _ResultCard(
                    result: result,
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

// ... باقي الكود (_ResultCard) يبقى كما هو بدون تغيير ...
class _ResultCard extends StatelessWidget {
  final ExamResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = result.score >= 50;
    final Color color = isSuccess ? AppColors.success : AppColors.error;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                result.courseName,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                result.score.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
