import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/manage_exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/screens/add_edit_exam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageExamsScreen extends StatelessWidget {
  const ManageExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ExamCubit>()..fetchExams()),
        BlocProvider(create: (context) => sl<ManageExamCubit>()),
      ],
      child: const _ManageExamsView(),
    );
  }
}

class _ManageExamsView extends StatelessWidget {
  const _ManageExamsView();

  void _showDeleteDialog(BuildContext context, Exam exam) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف امتحان مادة "${exam.courseName}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageExamCubit>().deleteExam(id: exam.id);
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الامتحانات')),
      body: BlocListener<ManageExamCubit, ManageExamState>(
        listener: (context, state) {
          if (state is ManageExamSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            context.read<ExamCubit>().fetchExams();
          } else if (state is ManageExamFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExamFailure)
              return Center(child: Text('حدث خطأ: ${state.message}'));
            if (state is ExamSuccess) {
              if (state.exams.isEmpty)
                return const Center(child: Text('لا توجد امتحانات لعرضها.'));
              return ListView.builder(
                itemCount: state.exams.length,
                itemBuilder: (context, index) {
                  final exam = state.exams[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(exam.courseName),
                      subtitle: Text(
                        'التاريخ: ${exam.examDate} | الوقت: ${exam.startTime}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteDialog(context, exam),
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AddEditExamScreen(exam: exam),
                          ),
                        );
                        if (result == true)
                          context.read<ExamCubit>().fetchExams();
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('ابدأ بتحميل الامتحانات.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddEditExamScreen()),
          );
          if (result == true) context.read<ExamCubit>().fetchExams();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
