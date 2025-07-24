import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/manage_teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageTeachersScreen extends StatelessWidget {
  const ManageTeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<TeacherCubit>()..fetchTeachers()),
        BlocProvider(create: (context) => sl<ManageTeacherCubit>()),
      ],
      child: const _ManageTeachersView(),
    );
  }
}

class _ManageTeachersView extends StatelessWidget {
  const _ManageTeachersView();

  void _showDeleteDialog(BuildContext context, TeacherEntity teacher) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف المدرس "${teacher.fullName}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageTeacherCubit>().deleteTeacher(
                    id: teacher.id,
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
      appBar: AppBar(title: const Text('إدارة المدرسين')),
      body: BlocListener<ManageTeacherCubit, ManageTeacherState>(
        listener: (context, state) {
          if (state is ManageTeacherSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            context.read<TeacherCubit>().fetchTeachers();
          } else if (state is ManageTeacherFailure) {
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
        child: BlocBuilder<TeacherCubit, TeacherState>(
          builder: (context, state) {
            if (state is TeacherLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is TeacherFailure)
              return Center(child: Text('حدث خطأ: ${state.message}'));
            if (state is TeacherSuccess) {
              if (state.teachers.isEmpty)
                return const Center(child: Text('لا يوجد مدرسين لعرضهم.'));
              return ListView.builder(
                itemCount: state.teachers.length,
                itemBuilder: (context, index) {
                  final teacher = state.teachers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(teacher.fullName),
                      subtitle: Text('القسم: ${teacher.department}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteDialog(context, teacher),
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder:
                                (_) => AddEditTeacherScreen(teacher: teacher),
                          ),
                        );
                        if (result == true)
                          context.read<TeacherCubit>().fetchTeachers();
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('ابدأ بتحميل المدرسين.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddEditTeacherScreen()),
          );
          if (result == true) context.read<TeacherCubit>().fetchTeachers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
