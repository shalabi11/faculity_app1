// lib/features/main_screen/presentation/screens/exams_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart'; // <-- السطر الجديد هنا
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({
    super.key,
    required User user,
    required TabController tabController,
  });

  @override
  Widget build(BuildContext context) {
    // نقرأ حالة المصادقة للحصول على معلومات الطالب المسجل دخوله
    final authState = context.read<AuthCubit>().state;
    int? studentId;

    // الآن سيتعرف الكود على AuthSuccess
    if (authState is Authenticated) {
      studentId = authState.user.id;
    }

    // نوفر الـ Cubit الجديد لهذه الشاشة
    return BlocProvider(
      // نتأكد من وجود ID للطالب قبل طلب النتائج
      create:
          (context) =>
              sl<StudentExamResultsCubit>()
                ..fetchStudentResults(studentId: studentId ?? 0),
      child: const _ExamsView(),
    );
  }
}

class _ExamsView extends StatelessWidget {
  const _ExamsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نتائج الامتحانات'),
        automaticallyImplyLeading: false, // لإخفاء سهم الرجوع
      ),
      body: BlocBuilder<StudentExamResultsCubit, StudentExamResultsState>(
        builder: (context, state) {
          if (state is StudentExamResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentExamResultsFailure) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          } else if (state is StudentExamResultsSuccess) {
            if (state.results.isEmpty) {
              return const Center(
                child: Text('لا توجد نتائج امتحانات لعرضها حاليًا.'),
              );
            }
            // عرض النتائج في حال النجاح
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      result.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      result.score.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: result.score >= 50 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            );
          }
          // الحالة الأولية أو أي حالة أخرى
          return const Center(child: Text('جاري تحميل النتائج...'));
        },
      ),
    );
  }
}
