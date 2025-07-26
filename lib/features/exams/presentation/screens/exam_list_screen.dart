import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/manage_exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/screens/add_edit_exam_screen.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ExamCubit>()..fetchExams()),
        BlocProvider(create: (context) => di.sl<ManageExamCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الامتحانات'),
          centerTitle: true,
        ),
        body: BlocListener<ManageExamCubit, ManageExamState>(
          listener: (context, state) {
            if (state is ManageExamSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // بعد نجاح أي عملية، قم بتحديث القائمة
              context.read<ExamCubit>().fetchExams();
            } else if (state is ManageExamFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              if (state is ExamLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExamLoaded) {
                return _buildExamList(context, state.exams);
              } else if (state is ExamError) {
                return Center(
                  child: Text('فشل في جلب البيانات: ${state.message}'),
                );
              }
              return const Center(child: Text('جاري بدء التحميل...'));
            },
          ),
        ),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () => _navigateToAddEditScreen(context),
                backgroundColor: Colors.red,
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }

  void _navigateToAddEditScreen(BuildContext context, {ExamEntity? exam}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditExamScreen(exam: exam)),
    ).then((result) {
      if (result == true) {
        context.read<ExamCubit>().fetchExams();
      }
    });
  }

  Widget _buildExamList(BuildContext context, List<ExamEntity> exams) {
    if (exams.isEmpty) {
      return const Center(child: Text('لا يوجد امتحانات مجدولة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          child: ListTile(
            title: Text(
              exam.courseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'التاريخ: ${exam.examDate} | الوقت: ${exam.startTime}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
                  onPressed:
                      () => _navigateToAddEditScreen(context, exam: exam),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: Text(
                              'هل أنت متأكد من رغبتك في حذف امتحان مقرر ${exam.courseName}؟',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('إلغاء'),
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('حذف'),
                                onPressed: () {
                                  context.read<ManageExamCubit>().deleteExam(
                                    id: exam.id,
                                  );
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          ),
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
}
