import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_cubit.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_state.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DistributeHallsScreen extends StatelessWidget {
  const DistributeHallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ExamCubit>()..fetchExams()),
        BlocProvider(create: (context) => sl<ExamHallAssignmentCubit>()),
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
            // بعد نجاح التوزيع، قم بجلب النتائج تلقائيًا
            context.read<ExamHallAssignmentCubit>().getAssignments(
              examId: _selectedExamId!,
            );
          } else if (state is ExamHallAssignmentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildExamDropdown(),
              const SizedBox(height: 20),
              BlocBuilder<ExamHallAssignmentCubit, ExamHallAssignmentState>(
                builder: (context, state) {
                  if (state is ExamHallAssignmentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed:
                        _selectedExamId == null
                            ? null
                            : () {
                              context
                                  .read<ExamHallAssignmentCubit>()
                                  .distributeHalls(examId: _selectedExamId!);
                            },
                    child: const Text('بدء عملية التوزيع'),
                  );
                },
              ),
              const Divider(height: 40),
              const Text(
                'نتائج التوزيع:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildResultsView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamDropdown() {
    return BlocBuilder<ExamCubit, ExamState>(
      builder: (context, state) {
        if (state is ExamLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is ExamSuccess) {
          return DropdownButtonFormField<int>(
            value: _selectedExamId,
            hint: const Text('اختر الامتحان'),
            items:
                state.exams.map((Exam exam) {
                  return DropdownMenuItem<int>(
                    value: exam.id,
                    child: Text(exam.courseName),
                  );
                }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedExamId = newValue;
                if (newValue != null) {
                  // جلب التوزيع الحالي عند اختيار امتحان
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
    );
  }

  Widget _buildResultsView() {
    return BlocBuilder<ExamHallAssignmentCubit, ExamHallAssignmentState>(
      builder: (context, state) {
        if (state is ExamHallAssignmentLoading) {
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
          return ListView.builder(
            itemCount: state.assignments.length,
            itemBuilder: (context, index) {
              final assignment = state.assignments[index];
              return Card(
                child: ListTile(
                  title: Text(assignment.studentName),
                  subtitle: Text('الرقم الجامعي: ${assignment.universityId}'),
                  trailing: Text('القاعة: ${assignment.classroomName}'),
                ),
              );
            },
          );
        }
        return const Center(child: Text('اختر امتحانًا لعرض أو بدء التوزيع.'));
      },
    );
  }
}
