import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/manage_classroom_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditClassroomScreen extends StatelessWidget {
  final Classroom? classroom;
  const AddEditClassroomScreen({super.key, this.classroom});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ManageClassroomCubit>(),
      child: _AddEditClassroomView(classroom: classroom),
    );
  }
}

class _AddEditClassroomView extends StatefulWidget {
  final Classroom? classroom;
  const _AddEditClassroomView({this.classroom});

  @override
  State<_AddEditClassroomView> createState() => _AddEditClassroomViewState();
}

class _AddEditClassroomViewState extends State<_AddEditClassroomView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _typeController;

  bool get _isEditMode => widget.classroom != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.classroom?.name ?? '');
    _typeController = TextEditingController(text: widget.classroom?.type ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final classroomData = {
        'name': _nameController.text,
        'type': _typeController.text,
      };

      if (_isEditMode) {
        context.read<ManageClassroomCubit>().updateClassroom(
          id: widget.classroom!.id,
          classroomData: classroomData,
        );
      } else {
        context.read<ManageClassroomCubit>().addClassroom(
          classroomData: classroomData,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل القاعة' : 'إضافة قاعة جديدة'),
      ),
      body: BlocListener<ManageClassroomCubit, ManageClassroomState>(
        listener: (context, state) {
          if (state is ManageClassroomSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ManageClassroomFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم القاعة'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'نوع القاعة (نظري/عملي)',
                ),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 24),
              BlocBuilder<ManageClassroomCubit, ManageClassroomState>(
                builder: (context, state) {
                  if (state is ManageClassroomLoading) {
                    return const Center(child: LoadingList());
                  }
                  return ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ القاعة'),
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
