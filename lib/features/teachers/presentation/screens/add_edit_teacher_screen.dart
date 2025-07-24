import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/manage_teacher_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditTeacherScreen extends StatelessWidget {
  final TeacherEntity? teacher;
  const AddEditTeacherScreen({super.key, this.teacher});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ManageTeacherCubit>(),
      child: _AddEditTeacherView(teacher: teacher),
    );
  }
}

class _AddEditTeacherView extends StatefulWidget {
  final TeacherEntity? teacher;
  const _AddEditTeacherView({this.teacher});

  @override
  State<_AddEditTeacherView> createState() => _AddEditTeacherViewState();
}

class _AddEditTeacherViewState extends State<_AddEditTeacherView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _motherNameController;
  // late TextEditingController _birthDateController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _academicDegreeController;
  late TextEditingController _degreeSourceController;
  late TextEditingController _departmentController;
  late TextEditingController _positionController;
  DateTime? _selectedBirthDate;

  bool get _isEditMode => widget.teacher != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.teacher?.fullName ?? '',
    );
    _motherNameController = TextEditingController(
      text: widget.teacher?.motherName ?? '',
    );
    _selectedBirthDate =
        widget.teacher != null
            ? DateTime.parse(widget.teacher!.birthDate)
            : null;
    _birthPlaceController = TextEditingController(
      text: widget.teacher?.birthPlace ?? '',
    );
    _academicDegreeController = TextEditingController(
      text: widget.teacher?.academicDegree ?? '',
    );
    _degreeSourceController = TextEditingController(
      text: widget.teacher?.degreeSource ?? '',
    );
    _departmentController = TextEditingController(
      text: widget.teacher?.department ?? '',
    );
    _positionController = TextEditingController(
      text: widget.teacher?.position ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _motherNameController.dispose();
    // _birthDateController has been removed.
    _birthPlaceController.dispose();
    _academicDegreeController.dispose();
    _degreeSourceController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final teacherData = {
        'full_name': _fullNameController.text,
        'mother_name': _motherNameController.text,
        'birth_date': _selectedBirthDate!.toIso8601String().substring(0, 10),
        'birth_place': _birthPlaceController.text,
        'academic_degree': _academicDegreeController.text,
        'degree_source': _degreeSourceController.text,
        'department': _departmentController.text,
        'position': _positionController.text,
      };

      if (_isEditMode) {
        context.read<ManageTeacherCubit>().updateTeacher(
          id: widget.teacher!.id,
          teacherData: teacherData,
        );
      } else if (_selectedBirthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار تاريخ الميلاد'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        context.read<ManageTeacherCubit>().addTeacher(teacherData: teacherData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل بيانات المدرس' : 'إضافة مدرس جديد'),
      ),
      body: BlocListener<ManageTeacherCubit, ManageTeacherState>(
        listener: (context, state) {
          if (state is ManageTeacherSuccess) {
            Navigator.pop(context, true);
          } else if (state is ManageTeacherFailure) {
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
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _motherNameController,
                decoration: const InputDecoration(labelText: 'اسم الأم'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              // 5. استبدل TextFormField الخاص بتاريخ الميلاد بهذا الكود
              InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedBirthDate ?? DateTime.now(),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedBirthDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الميلاد',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _selectedBirthDate != null
                            ? '${_selectedBirthDate!.year}/${_selectedBirthDate!.month}/${_selectedBirthDate!.day}'
                            : 'اختر تاريخاً',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(labelText: 'مكان الولادة'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _academicDegreeController,
                decoration: const InputDecoration(labelText: 'الشهادة العلمية'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _degreeSourceController,
                decoration: const InputDecoration(labelText: 'مصدر الشهادة'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'القسم'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: 'المنصب'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 24),
              BlocBuilder<ManageTeacherCubit, ManageTeacherState>(
                builder: (context, state) {
                  if (state is ManageTeacherLoading)
                    return const Center(child: CircularProgressIndicator());
                  return ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ المدرس'),
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
