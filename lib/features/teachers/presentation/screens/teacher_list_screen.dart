import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/manage_teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير كلا الـ Cubits للشاشة
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<TeacherCubit>()..fetchTeachers(),
        ),
        BlocProvider(create: (context) => di.sl<ManageTeacherCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('قائمة الدكاترة'), centerTitle: true),
        // استخدام BlocListener للاستماع لنتائج الحذف والتعديل من ManageTeacherCubit
        body: BlocListener<ManageTeacherCubit, ManageTeacherState>(
          listener: (context, state) {
            if (state is ManageTeacherSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تمت العملية بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              // بعد نجاح أي عملية، نطلب من TeacherCubit تحديث القائمة
              context.read<TeacherCubit>().fetchTeachers();
            } else if (state is ManageTeacherFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<TeacherCubit, TeacherState>(
            builder: (context, state) {
              if (state is TeacherLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TeacherSuccess) {
                return _buildTeachersList(context, state.teachers);
              } else if (state is TeacherFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('فشل في جلب البيانات: ${state.message}'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.read<TeacherCubit>().fetchTeachers();
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
        // استخدام Builder لضمان وصول الـ context الصحيح للـ FloatingActionButton
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditTeacherScreen(),
                    ),
                  ).then((result) {
                    // إذا تمت الإضافة أو التعديل بنجاح، قم بتحديث القائمة
                    if (result == true) {
                      context.read<TeacherCubit>().fetchTeachers();
                    }
                  });
                },
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }

  // ويدجت خاصة لبناء قائمة الدكاترة
  Widget _buildTeachersList(
    BuildContext context,
    List<TeacherEntity> teachers,
  ) {
    if (teachers.isEmpty) {
      return const Center(child: Text('لا يوجد دكاترة لعرضهم.'));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TeacherCubit>().fetchTeachers();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.person_outline, color: Colors.teal),
              ),
              title: Text(
                teacher.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${teacher.department} - ${teacher.position}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.blue.shade600,
                    ),
                    onPressed: () {
                      // الانتقال إلى شاشة التعديل مع تمرير بيانات الدكتور
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AddEditTeacherScreen(teacher: teacher),
                        ),
                      ).then((result) {
                        if (result == true) {
                          context.read<TeacherCubit>().fetchTeachers();
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
                      showDialog(
                        context: context,
                        builder:
                            (dialogContext) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: Text(
                                'هل أنت متأكد من رغبتك في حذف الدكتور ${teacher.fullName}؟',
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
                                    // استدعاء دالة الحذف من ManageTeacherCubit
                                    context
                                        .read<ManageTeacherCubit>()
                                        .deleteTeacher(id: teacher.id);
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
