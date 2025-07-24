import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/manage_course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/screens/add_edit_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageCoursesScreen extends StatelessWidget {
  const ManageCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<CourseCubit>()..fetchCourses()),
        BlocProvider(create: (context) => sl<ManageCourseCubit>()),
      ],
      child: const _ManageCoursesView(),
    );
  }
}

class _ManageCoursesView extends StatelessWidget {
  const _ManageCoursesView();

  void _showDeleteDialog(BuildContext context, CourseEntity course) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text('هل أنت متأكد أنك تريد حذف مادة "${course.name}"؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageCourseCubit>().deleteCourse(id: course.id);
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
      appBar: AppBar(title: const Text('إدارة المواد')),
      body: BlocListener<ManageCourseCubit, ManageCourseState>(
        listener: (context, state) {
          if (state is ManageCourseSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            context.read<CourseCubit>().fetchCourses();
          } else if (state is ManageCourseFailure) {
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
        child: BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is CourseError)
              return Center(child: Text('حدث خطأ: ${state.message}'));
            if (state is CourseLoaded) {
              if (state.courses.isEmpty)
                return const Center(child: Text('لا توجد مواد لعرضها.'));
              return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(course.name),
                      subtitle: Text(
                        'القسم: ${course.department} | السنة: ${course.year}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteDialog(context, course),
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AddEditCourseScreen(course: course),
                          ),
                        );
                        if (result == true)
                          context.read<CourseCubit>().fetchCourses();
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('ابدأ بتحميل المواد.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddEditCourseScreen()),
          );
          if (result == true) context.read<CourseCubit>().fetchCourses();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
