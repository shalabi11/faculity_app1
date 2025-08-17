// lib/features/teachers/presentation/screens/teacher_courses_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_job/teacher_courses_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_job/teacher_courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCoursesScreen extends StatelessWidget {
  final User user;
  const TeacherCoursesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return const _TeacherCoursesView();
  }
}

class _TeacherCoursesView extends StatelessWidget {
  const _TeacherCoursesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeacherCoursesCubit, TeacherCoursesState>(
        builder: (context, state) {
          if (state is TeacherCoursesLoading) {
            return const LoadingList(itemCount: 4, cardHeight: 90);
          }
          if (state is TeacherCoursesFailure) {
            return ErrorState(
              message: state.message,
              onRetry: () {
                final user =
                    context
                        .findAncestorWidgetOfExactType<TeacherCoursesScreen>()
                        ?.user;
                if (user != null) {
                  context.read<TeacherCoursesCubit>().fetchTeacherCourses(
                    user.name,
                  );
                }
              },
            );
          }
          if (state is TeacherCoursesSuccess) {
            if (state.courses.isEmpty) {
              return const EmptyState(
                message: 'أنت غير مسجل على أي مقررات حالياً.',
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final user =
                    context
                        .findAncestorWidgetOfExactType<TeacherCoursesScreen>()
                        ?.user;
                if (user != null) {
                  context.read<TeacherCoursesCubit>().fetchTeacherCourses(
                    user.name,
                  );
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  return _CourseCard(course: state.courses[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ويدجت لعرض بطاقة المقرر
class _CourseCard extends StatelessWidget {
  final CourseEntity course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            Icons.book_outlined,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('السنة: ${course.year} - القسم: ${course.department}'),
        // يمكنك إضافة onTap هنا للانتقال إلى تفاصيل المقرر
      ),
    );
  }
}
