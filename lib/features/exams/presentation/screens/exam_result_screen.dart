import 'package:faculity_app2/features/exams/presentation/screens/grade_entry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
// لاحقاً سنقوم بإنشاء هذه الشاشة
// import 'packagepackage:faculity_app2/features/exams/presentation/screens/grade_entry_screen.dart';

class ExamSelectionForResultsScreen extends StatelessWidget {
  const ExamSelectionForResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ExamCubit>()..fetchExams(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختر امتحاناً لإدخال العلامات'),
          centerTitle: true,
        ),
        body: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExamLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.exams.length,
                itemBuilder: (context, index) {
                  final exam = state.exams[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        exam.courseName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('تاريخ الامتحان: ${exam.examDate}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // --- قم بتفعيل هذا الكود ---
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // الانتقال إلى شاشة إدخال العلامات مع تمرير بيانات الامتحان
                            builder: (_) => GradeEntryScreen(exam: exam),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (state is ExamError) {
              return Center(
                child: Text('فشل في جلب الامتحانات: ${state.message}'),
              );
            }
            return const Center(child: Text('جاري التحميل...'));
          },
        ),
      ),
    );
  }
}
