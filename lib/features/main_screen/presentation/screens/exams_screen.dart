import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ExamsScreen extends StatelessWidget {
  final User user;
  final TabController tabController;

  const ExamsScreen({
    super.key,
    required this.user,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام BlocProvider هنا لتوفير نفس الـ Cubit لكلا التبويبين
    return BlocProvider(
      create: (context) => sl<ExamsCubit>(),
      child: TabBarView(
        controller: tabController,
        children: [
          _ExamsScheduleView(user: user),
          _ExamResultsView(user: user),
        ],
      ),
    );
  }
}

// ===============================================
//  ويدجت عرض جدول الامتحانات
// ===============================================
class _ExamsScheduleView extends StatefulWidget {
  final User user;
  const _ExamsScheduleView({required this.user});

  @override
  State<_ExamsScheduleView> createState() => _ExamsScheduleViewState();
}

class _ExamsScheduleViewState extends State<_ExamsScheduleView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // جلب البيانات مرة واحدة عند بناء الويدجت
    context.read<ExamsCubit>().fetchExams();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ExamsCubit, ExamsState>(
      builder: (context, state) {
        if (state.examsStatus == ExamsStatus.loading) {
          return const _LoadingListWidget();
        }
        if (state.examsStatus == ExamsStatus.error) {
          return Center(child: Text(state.errorMessage ?? 'حدث خطأ'));
        }
        if (state.examsStatus == ExamsStatus.loaded) {
          if (state.exams.isEmpty) {
            return const Center(
              child: Text('لم يتم تحديد مواعيد الامتحانات بعد.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.exams.length,
            itemBuilder: (context, index) {
              return _ExamCard(exam: state.exams[index]);
            },
          ).animate().fade(duration: 400.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ===============================================
//  ويدجت عرض نتائج الامتحانات
// ===============================================
class _ExamResultsView extends StatefulWidget {
  final User user;
  const _ExamResultsView({required this.user});

  @override
  State<_ExamResultsView> createState() => _ExamResultsViewState();
}

class _ExamResultsViewState extends State<_ExamResultsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ExamsCubit>().fetchStudentResults(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ExamsCubit, ExamsState>(
      builder: (context, state) {
        if (state.resultsStatus == ExamsStatus.loading) {
          return const _LoadingListWidget();
        }
        if (state.resultsStatus == ExamsStatus.error) {
          return Center(child: Text(state.errorMessage ?? 'حدث خطأ'));
        }
        if (state.resultsStatus == ExamsStatus.loaded) {
          if (state.results.isEmpty) {
            return const Center(child: Text('لم تصدر أي نتائج بعد.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return _ResultCard(result: state.results[index]);
            },
          ).animate().fade(duration: 400.ms);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ===============================================
//  ويدجتس مساعدة (البطاقات وحالة التحميل)
// ===============================================
class _ExamCard extends StatelessWidget {
  final Exam exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.event_note_outlined,
          color: AppColors.primary,
        ),
        title: Text(
          exam.courseName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('التاريخ: ${exam.date}'),
        trailing: Text(
          '${exam.startTime} - ${exam.endTime}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final ExamResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = result.score >= 50;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          result.courseName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:
                isSuccess
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            result.score.toStringAsFixed(1),
            style: TextStyle(
              color: isSuccess ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingListWidget extends StatelessWidget {
  const _LoadingListWidget();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const ShimmerContainer(
                width: 40,
                height: 40,
                borderRadius: 8,
              ),
              title: const ShimmerContainer(height: 14, width: 150),
              subtitle: const ShimmerContainer(height: 12, width: 100),
            ),
          );
        },
      ),
    );
  }
}
