import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_cubit.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_state.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/manage_classroom_cubit.dart';
import 'package:faculity_app2/features/classrooms/presentation/screens/add_edit_classroom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageClassroomsScreen extends StatelessWidget {
  const ManageClassroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ClassroomCubit>()..fetchClassrooms(),
        ),
        BlocProvider(create: (context) => sl<ManageClassroomCubit>()),
      ],
      child: const _ManageClassroomsView(),
    );
  }
}

class _ManageClassroomsView extends StatelessWidget {
  const _ManageClassroomsView();

  void _showDeleteDialog(BuildContext context, Classroom classroom) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف قاعة "${classroom.name}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageClassroomCubit>().deleteClassroom(
                    id: classroom.id,
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
      appBar: AppBar(title: const Text('إدارة القاعات الدراسية')),
      body: BlocListener<ManageClassroomCubit, ManageClassroomState>(
        listener: (context, state) {
          if (state is ManageClassroomSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            context.read<ClassroomCubit>().fetchClassrooms();
          } else if (state is ManageClassroomFailure) {
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
        child: BlocBuilder<ClassroomCubit, ClassroomState>(
          builder: (context, state) {
            if (state is ClassroomLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is ClassroomFailure)
              return Center(child: Text('حدث خطأ: ${state.message}'));
            if (state is ClassroomSuccess) {
              if (state.classrooms.isEmpty)
                return const Center(child: Text('لا توجد قاعات لعرضها.'));
              return ListView.builder(
                itemCount: state.classrooms.length,
                itemBuilder: (context, index) {
                  final classroom = state.classrooms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(classroom.name),
                      subtitle: Text('النوع: ${classroom.type}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteDialog(context, classroom),
                      ),
                      onTap: () async {
                        final result = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder:
                                (_) => AddEditClassroomScreen(
                                  classroom: classroom,
                                ),
                          ),
                        );
                        if (result == true)
                          context.read<ClassroomCubit>().fetchClassrooms();
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('ابدأ بتحميل القاعات.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const AddEditClassroomScreen()),
          );
          if (result == true) context.read<ClassroomCubit>().fetchClassrooms();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
