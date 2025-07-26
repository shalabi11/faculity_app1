import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_distribution_result_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;

import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_distribution_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_distribution_state.dart';

class ExamDistributionScreen extends StatelessWidget {
  const ExamDistributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير كلا الـ Cubits
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ExamCubit>()..fetchExams()),
        BlocProvider(create: (context) => di.sl<ExamDistributionCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('توزيع القاعات الامتحانية'),
          centerTitle: true,
        ),
        body: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExamLoaded) {
              return _buildExamsList(context, state.exams);
            } else if (state is ExamError) {
              return Center(child: Text('فشل: ${state.message}'));
            }
            return const Center(child: Text('جاري تحميل الامتحانات...'));
          },
        ),
      ),
    );
  }

  Widget _buildExamsList(BuildContext context, List<ExamEntity> exams) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.courseName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('تاريخ الامتحان: ${exam.examDate}'),
                    ],
                  ),
                ),
                // استخدام BlocBuilder لعرض حالة الزر (عادي أو تحميل)
                BlocBuilder<ExamDistributionCubit, ExamDistributionState>(
                  builder: (context, distState) {
                    if (distState is ExamDistributionLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        // بدء عملية التوزيع وعرض النتائج في صندوق حوار
                        context
                            .read<ExamDistributionCubit>()
                            .distributeHalls(exam.id)
                            .then((_) {
                              final currentState =
                                  context.read<ExamDistributionCubit>().state;
                              if (currentState is ExamDistributionSuccess) {
                                _showDistributionResults(
                                  context,
                                  currentState.results,
                                );
                              } else if (currentState
                                  is ExamDistributionFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(currentState.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                      },
                      child: const Text('بدء التوزيع'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // دالة لعرض النتائج في نافذة منبثقة
  void _showDistributionResults(
    BuildContext context,
    List<ExamDistributionResultEntity> results,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('نتائج توزيع القاعات'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return ListTile(
                    title: Text(result.studentName),
                    subtitle: Text('الرقم الجامعي: ${result.universityId}'),
                    trailing: Text(
                      result.classroomName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
    );
  }
}
