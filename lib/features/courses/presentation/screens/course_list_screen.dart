import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/manage_course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/screens/add_edit_course_screen.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استخدام MultiBlocProvider لتوفير كلا الـ Cubits
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<CourseCubit>()..fetchCourses()),
        BlocProvider(create: (context) => di.sl<ManageCourseCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة المقررات الدراسية'),
          centerTitle: true,
        ),
        // 2. استخدام BlocListener للاستماع لنتائج العمليات من ManageCourseCubit
        body: BlocListener<ManageCourseCubit, ManageCourseState>(
          listener: (context, state) {
            if (state is ManageCourseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // بعد نجاح أي عملية، نطلب من CourseCubit تحديث القائمة
              context.read<CourseCubit>().fetchCourses();
            } else if (state is ManageCourseFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<CourseCubit, CourseState>(
            builder: (context, state) {
              if (state is CourseLoading) {
                return const Center(child: LoadingList());
              } else if (state is CourseLoaded) {
                return _buildCourseList(context, state.courses);
              } else if (state is CourseError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('فشل في جلب البيانات: ${state.message}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CourseCubit>().fetchCourses();
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('جاري بدء التحميل...'));
            },
          ),
        ),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditCourseScreen(),
                    ),
                  ).then((result) {
                    if (result == true) {
                      context.read<CourseCubit>().fetchCourses();
                    }
                  });
                },
                backgroundColor: Colors.purple,
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }

  // ويدجت خاصة لبناء قائمة المقررات
  Widget _buildCourseList(BuildContext context, List<CourseEntity> courses) {
    if (courses.isEmpty) {
      return const Center(child: Text('لا يوجد مقررات لعرضها.'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CourseCubit>().fetchCourses();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple.shade100,
                child: const Icon(Icons.book_outlined, color: Colors.purple),
              ),
              title: Text(
                course.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('السنة ${course.year} - قسم ${course.department}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.blue.shade600,
                    ),
                    onPressed: () {
                      // 3. تفعيل زر التعديل
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditCourseScreen(course: course),
                        ),
                      ).then((result) {
                        if (result == true) {
                          context.read<CourseCubit>().fetchCourses();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade600,
                    ),
                    onPressed: () {
                      // 4. تفعيل زر الحذف
                      showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: Text(
                                'هل أنت متأكد من رغبتك في حذف مقرر ${course.name}؟',
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
                                    context
                                        .read<ManageCourseCubit>()
                                        .deleteCourse(id: course.id);
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
      ),
    );
  }
}
