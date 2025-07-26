import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;

import 'package:faculity_app2/features/exams/presentation/cubit/grade_entry_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/grade_entry_state.dart';

class GradeEntryScreen extends StatelessWidget {
  final ExamEntity exam;
  const GradeEntryScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => di.sl<GradeEntryCubit>()..fetchStudentsForExam(exam.id),
      child: _GradeEntryView(exam: exam),
    );
  }
}

class _GradeEntryView extends StatefulWidget {
  final ExamEntity exam;
  const _GradeEntryView({required this.exam});

  @override
  State<_GradeEntryView> createState() => _GradeEntryViewState();
}

class _GradeEntryViewState extends State<_GradeEntryView> {
  // قائمة لتخزين الـ controllers الخاصة بكل طالب
  late Map<int, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {};
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _saveGrades(BuildContext context) {
    final List<Map<String, dynamic>> gradesToSave = [];
    _controllers.forEach((resultId, controller) {
      if (controller.text.isNotEmpty) {
        gradesToSave.add({'id': resultId, 'score': controller.text});
      }
    });
    if (gradesToSave.isNotEmpty) {
      context.read<GradeEntryCubit>().saveGrades(gradesToSave);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدخال علامات: ${widget.exam.courseName}'),
        actions: [
          BlocBuilder<GradeEntryCubit, GradeEntryState>(
            builder: (context, state) {
              if (state is GradeSaving) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              return IconButton(
                icon: const Icon(Icons.save_alt_outlined),
                onPressed: () => _saveGrades(context),
                tooltip: 'حفظ العلامات',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<GradeEntryCubit, GradeEntryState>(
        listener: (context, state) {
          if (state is GradeSaveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم حفظ العلامات بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is GradeEntryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GradeEntryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GradeEntryLoaded) {
            // تهيئة الـ controllers عند تحميل الطلاب
            _controllers.clear();
            for (var studentResult in state.students) {
              _controllers[studentResult.resultId] = TextEditingController(
                text: studentResult.score?.toString() ?? '',
              );
            }
            return _buildStudentsList(state.students);
          }
          return const Center(child: Text('جاري تحميل الطلاب...'));
        },
      ),
    );
  }

  Widget _buildStudentsList(List<ExamResultEntity> students) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final studentResult = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(child: Text('${index + 1}')),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    studentResult.studentName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _controllers[studentResult.resultId],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'العلامة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
