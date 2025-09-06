// lib/features/teachers/presentation/screens/add_edit_teacher_screen/add_edit_teacher_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/manage_teacher/manage_teacher_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEditTeacherScreen extends StatefulWidget {
  final TeacherEntity? teacher;
  final Map<String, dynamic>? initialData;

  const AddEditTeacherScreen({super.key, this.teacher, this.initialData});

  @override
  State<AddEditTeacherScreen> createState() => _AddEditTeacherScreenState();
}

class _AddEditTeacherScreenState extends State<AddEditTeacherScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers للحقول الجديدة حسب TeacherEntity
  final _fullNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _academicDegreeController = TextEditingController();
  final _degreeSourceController = TextEditingController();
  final _departmentController = TextEditingController();
  final _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تعبئة الحقول تلقائياً من شاشة إنشاء الحساب
    if (widget.initialData != null) {
      _fullNameController.text = widget.initialData!['name'] ?? '';
      _departmentController.text = widget.initialData!['department'] ?? '';
      _positionController.text = widget.initialData!['position'] ?? '';
    } else if (widget.teacher != null) {
      // منطق تعديل دكتور موجود
      _fullNameController.text = widget.teacher!.fullName;
      _motherNameController.text = widget.teacher!.motherName;
      _birthDateController.text = widget.teacher!.birthDate;
      _birthPlaceController.text = widget.teacher!.birthPlace;
      _academicDegreeController.text = widget.teacher!.academicDegree;
      _degreeSourceController.text = widget.teacher!.degreeSource;
      _departmentController.text = widget.teacher!.department;
      _positionController.text = widget.teacher!.position;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _academicDegreeController.dispose();
    _degreeSourceController.dispose();
    _departmentController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveTeacher() {
    if (_formKey.currentState!.validate()) {
      final teacherData = {
        'full_name': _fullNameController.text.trim(),
        'mother_name': _motherNameController.text.trim(),
        'birth_date': _birthDateController.text.trim(),
        'birth_place': _birthPlaceController.text.trim(),
        'academic_degree': _academicDegreeController.text.trim(),
        'degree_source': _degreeSourceController.text.trim(),
        'department': _departmentController.text.trim(),
        'position': _positionController.text.trim(),
      };

      if (widget.teacher == null) {
        context.read<ManageTeacherCubit>().addTeacher(teacherData: teacherData);
      } else {
        context.read<ManageTeacherCubit>().updateTeacher(
          id: widget.teacher!.id,
          teacherData: teacherData,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageTeacherCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.teacher == null
                ? 'إضافة بيانات دكتور'
                : 'تعديل بيانات دكتور',
          ),
        ),
        body: BlocConsumer<ManageTeacherCubit, ManageTeacherState>(
          listener: (context, state) {
            if (state is ManageTeacherSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              int count = 0;
              Navigator.of(context).popUntil(
                (_) => count++ >= (widget.initialData != null ? 2 : 1),
              );
            } else if (state is ManageTeacherFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل العملية: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ManageTeacherLoading;
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _fullNameController,
                      label: 'الاسم الكامل',
                      readOnly: widget.initialData != null,
                    ),
                    _buildTextField(
                      controller: _motherNameController,
                      label: 'اسم الأم',
                    ),
                    _buildDateField(context),
                    _buildTextField(
                      controller: _birthPlaceController,
                      label: 'مكان الولادة',
                    ),
                    _buildTextField(
                      controller: _academicDegreeController,
                      label: 'الدرجة العلمية',
                    ),
                    _buildTextField(
                      controller: _degreeSourceController,
                      label: 'مصدر الشهادة',
                    ),
                    _buildTextField(
                      controller: _departmentController,
                      label: 'القسم',
                      readOnly: widget.initialData != null,
                    ),
                    _buildTextField(
                      controller: _positionController,
                      label: 'المنصب',
                      readOnly: widget.initialData != null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveTeacher,
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('حفظ البيانات'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          fillColor: readOnly ? Colors.grey.shade200 : null,
          filled: readOnly,
        ),
        validator:
            (value) =>
                (value == null || value.trim().isEmpty)
                    ? 'هذا الحقل مطلوب'
                    : null,
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _birthDateController,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'تاريخ الميلاد',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context),
        validator:
            (value) =>
                (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }
}
