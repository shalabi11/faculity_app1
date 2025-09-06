// lib/features/student_affairs/presentation/screens/manage_students_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManageStudentsScreen extends StatelessWidget {
  const ManageStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<StudentAffairsCubit>()..fetchStudents(),
        ),
        BlocProvider(create: (context) => sl<ManageStudentCubit>()),
      ],
      child: const _ManageStudentsView(),
    );
  }
}

class _ManageStudentsView extends StatelessWidget {
  const _ManageStudentsView();

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
            context.read<StudentAffairsCubit>().fetchStudents();
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
        child: BlocBuilder<StudentAffairsCubit, StudentAffairsState>(
          builder: (context, state) {
            if (state is StudentAffairsLoading) {
              return const _LoadingShimmerList();
            } else if (state is StudentAffairsError) {
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else if (state is StudentAffairsLoaded) {
              if (state.students.isEmpty) {
                return const Center(child: Text('لا يوجد طلاب لعرضهم.'));
              }
              return RefreshIndicator(
                onRefresh:
                    () async =>
                        context.read<StudentAffairsCubit>().fetchStudents(),
                child: ListView.builder(
                  itemCount: state.students.length,
                  itemBuilder: (context, index) {
                    final student = state.students[index];
                    return _StudentCard(
                      student: student,
                      onDelete:
                          () => _showDeleteConfirmationDialog(context, student),
                      onEdit: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(builder: (_) => AddStudentScreen()),
                        );
                        if (result == true) {
                          context.read<StudentAffairsCubit>().fetchStudents();
                        }
                      },
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder:
                                (_) => StudentDetailsScreen(student: student),
                          ),
                        );
                        if (result == true) {
                          context.read<StudentAffairsCubit>().fetchStudents();
                        }
                      },
                    );
                  },
                ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.5),
              );
            }
            return const Center(child: Text('ابدأ بتحميل الطلاب.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddStudentScreen()),
          );
          if (result == true) {
            context.read<StudentAffairsCubit>().fetchStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(student.fullName.isNotEmpty ? student.fullName[0] : ''),
        ),
        title: Text(student.fullName),
        subtitle: Text('الرقم الجامعي: ${student.universityId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingShimmerList extends StatelessWidget {
  const _LoadingShimmerList();
  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder:
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const ShimmerContainer.circular(size: 48),
                title: ShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 18,
                ),
                subtitle: ShimmerContainer(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14,
                ),
              ),
            ),
      ),
    );
  }
}
