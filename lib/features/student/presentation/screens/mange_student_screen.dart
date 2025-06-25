// lib/features/admin/presentation/screens/manage_students_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student/presentation/cubit/manage_student_cubit.dart';
import 'package:faculity_app2/features/student/presentation/cubit/student_cubit.dart';
import 'package:faculity_app2/features/student/presentation/screens/add_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManageStudentsScreen extends StatelessWidget {
  const ManageStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير كلا الـ Cubits للشاشة
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<StudentCubit>()..fetchStudents()),
        BlocProvider(create: (context) => sl<ManageStudentCubit>()),
      ],
      child: const _ManageStudentsView(),
    );
  }
}

class _ManageStudentsView extends StatelessWidget {
  const _ManageStudentsView();

  // دالة لعرض حوار تأكيد الحذف
  void _showDeleteConfirmationDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف الطالب "${student.fullName}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageStudentCubit>().deleteStudent(
                    id: student.id,
                  );
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
      appBar: AppBar(title: const Text('إدارة الطلاب')),
      // نستمع لنتائج عمليات الإضافة والحذف والتعديل
      body: BlocListener<ManageStudentCubit, ManageStudentState>(
        listener: (context, state) {
          if (state is ManageStudentSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            // عند أي عملية ناجحة، نقوم بتحديث قائمة الطلاب
            context.read<StudentCubit>().fetchStudents();
          } else if (state is ManageStudentFailure) {
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
        // نعرض قائمة الطلاب
        child: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            // عرض الشيمر أثناء التحميل
            if (state is StudentLoading) {
              return const _LoadingList();
            } else if (state is StudentFailure) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else if (state is StudentSuccess) {
              if (state.students.isEmpty) {
                return const Center(child: Text('لا يوجد طلاب لعرضهم.'));
              }
              // عرض القائمة مع حركة ديناميكية
              return ListView.builder(
                    itemCount: state.students.length,
                    itemBuilder: (context, index) {
                      final student = state.students[index];
                      // استخدام ويدجت البطاقة الجديد
                      return _StudentCard(
                        student: student,
                        onDelete:
                            () =>
                                _showDeleteConfirmationDialog(context, student),
                        onTap: () async {
                          final result = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder:
                                  (_) => AddEditStudentScreen(student: student),
                            ),
                          );
                          if (result == true) {
                            context.read<StudentCubit>().fetchStudents();
                          }
                        },
                      );
                    },
                  )
                  .animate(delay: 80.ms)
                  .fadeIn(duration: 300.ms, delay: 100.ms)
                  .slideY(begin: 0.5);
            }
            return const Center(child: Text('ابدأ بتحميل الطلاب.'));
          },
        ),
      ),
      // زر إضافة طالب جديد
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddEditStudentScreen()),
          );
          if (result == true) {
            context.read<StudentCubit>().fetchStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ويدجت بطاقة الطالب المحسن
class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Text(
                  student.fullName.isNotEmpty ? student.fullName[0] : 'S',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الرقم الجامعي: ${student.universityId}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              BlocBuilder<ManageStudentCubit, ManageStudentState>(
                builder: (context, state) {
                  if (state is ManageStudentLoading) {
                    return const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    );
                  }
                  return IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade400,
                    ),
                    onPressed: onDelete,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجت واجهة التحميل الهيكلية (Shimmer)
class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const ShimmerContainer.circular(size: 60),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerContainer(
                          width: 150,
                          height: 18,
                          borderRadius: 24,
                        ),
                        const SizedBox(height: 8),
                        const ShimmerContainer(
                          width: 200,
                          height: 14,
                          borderRadius: 24,
                        ),
                      ],
                    ),
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
