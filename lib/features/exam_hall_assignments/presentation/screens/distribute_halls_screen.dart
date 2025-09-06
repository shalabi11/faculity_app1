// lib/features/exam_hall_assignments/presentation/screens/distribute_halls_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_cubit.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_state.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistributeHallsScreen extends StatelessWidget {
  const DistributeHallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ExamCubit>()..fetchExams()),
        BlocProvider(create: (context) => di.sl<ExamHallAssignmentCubit>()),
      ],
      child: const _DistributeHallsView(),
    );
  }
}

class _DistributeHallsView extends StatefulWidget {
  const _DistributeHallsView();

  @override
  State<_DistributeHallsView> createState() => _DistributeHallsViewState();
}

class _DistributeHallsViewState extends State<_DistributeHallsView> {
  int? _selectedExamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('توزيع قاعات الامتحانات')),
      body: BlocListener<ExamHallAssignmentCubit, ExamHallAssignmentState>(
        listener: (context, state) {
          if (state is ExamHallAssignmentDistributionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت عملية التوزيع بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            // بعد نجاح التوزيع، قم بجلب النتائج لعرضها
            if (_selectedExamId != null) {
              context.read<ExamHallAssignmentCubit>().getAssignments(
                examId: _selectedExamId!,
              );
            }
          } else if (state is ExamHallAssignmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            if (_selectedExamId != null) {
              context.read<ExamHallAssignmentCubit>().getAssignments(
                examId: _selectedExamId!,
              );
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildStepCard(
                context,
                step: 1,
                title: 'اختيار الامتحان',
                content: _buildExamDropdown(),
              ),
              const SizedBox(height: 20),
              _buildStepCard(
                context,
                step: 2,
                title: 'نتائج التوزيع',
                content: _buildResultsView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء بطاقة الخطوة بتصميم موحد
  Widget _buildStepCard(
    BuildContext context, {
    required int step,
    required String title,
    required Widget content,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, child: Text('$step')),
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildExamDropdown() {
    return Column(
      children: [
        BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: LoadingList());
            }
            if (state is ExamLoaded) {
              return DropdownButtonFormField<int>(
                value: _selectedExamId,
                hint: const Text('اختر الامتحان لبدء التوزيع'),
                items:
                    state.exams.map((ExamEntity exam) {
                      return DropdownMenuItem<int>(
                        value: exam.id,
                        child: Text(exam.courseName),
                      );
                    }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedExamId = newValue;
                    if (newValue != null) {
                      // عند اختيار امتحان، قم بجلب التوزيعات الحالية له
                      context.read<ExamHallAssignmentCubit>().getAssignments(
                        examId: newValue,
                      );
                    }
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              );
            }
            return const Text('لا يمكن تحميل الامتحانات');
          },
        ),
        const SizedBox(height: 16),
        BlocBuilder<ExamHallAssignmentCubit, ExamHallAssignmentState>(
          builder: (context, state) {
            if (state is ExamHallAssignmentLoading) {
              return const Center(child: LoadingList());
            }
            return ElevatedButton.icon(
              icon: const Icon(Icons.shuffle),
              label: const Text('بدء عملية التوزيع'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed:
                  _selectedExamId == null
                      ? null
                      : () {
                        context.read<ExamHallAssignmentCubit>().distributeHalls(
                          examId: _selectedExamId!,
                        );
                      },
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    return BlocBuilder<ExamHallAssignmentCubit, ExamHallAssignmentState>(
      builder: (context, state) {
        if (state is ExamHallAssignmentLoading && _selectedExamId != null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ExamHallAssignmentFailure) {
          return Center(child: Text(state.message));
        }
        if (state is ExamHallAssignmentLoadSuccess) {
          if (state.assignments.isEmpty) {
            return const Center(
              child: Text('لم يتم توزيع الطلاب لهذا الامتحان بعد.'),
            );
          }
          // تجميع الطلاب حسب القاعة
          final Map<String, List<ExamHallAssignment>> groupedByClassroom = {};
          for (var assignment in state.assignments) {
            (groupedByClassroom[assignment.classroomName] ??= []).add(
              assignment,
            );
          }
          return Column(
            children:
                groupedByClassroom.entries.map((entry) {
                  final classroomName = entry.key;
                  final students = entry.value;
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(
                        '$classroomName (${students.length} طالب)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children:
                          students.map((student) {
                            return ListTile(
                              title: Text(student.studentName),
                              subtitle: Text(
                                'الرقم الجامعي: ${student.universityId}',
                              ),
                              dense: true,
                            );
                          }).toList(),
                    ),
                  );
                }).toList(),
          );
        }
        return const Center(child: Text('اختر امتحانًا لعرض نتائج التوزيع.'));
      },
    );
  }
}
