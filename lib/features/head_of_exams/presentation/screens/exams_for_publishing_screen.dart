import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/head_of_exams/presentation/cubit/head_of_exams_cubit.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/cubit/head_of_exams_state.dart';

class ExamsForPublishingScreen extends StatelessWidget {
  const ExamsForPublishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HeadOfExamsCubit>()..fetchPublishableExams(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نشر نتائج الامتحانات'),
          centerTitle: true,
        ),
        body: BlocConsumer<HeadOfExamsCubit, HeadOfExamsState>(
          listener: (context, state) {
            if (state is PublishSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is HeadOfExamsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HeadOfExamsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HeadOfExamsLoaded) {
              if (state.exams.isEmpty) {
                return const Center(
                  child: Text('لا يوجد امتحانات جاهزة للنشر حالياً.'),
                );
              }
              return _buildExamsList(context, state.exams);
            } else if (state is HeadOfExamsFailure) {
              return Center(child: Text(state.message));
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
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text('تاريخ الامتحان: ${exam.examDate}'),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.rate_review_outlined),
                      label: const Text('مراجعة العلامات'),
                      onPressed: () {
                        // يمكنك هنا الانتقال لشاشة عرض العلامات للقراءة فقط
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.publish_outlined),
                      label: const Text('نشر النتائج'),
                      onPressed: () {
                        context.read<HeadOfExamsCubit>().publishResults(
                          exam.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
