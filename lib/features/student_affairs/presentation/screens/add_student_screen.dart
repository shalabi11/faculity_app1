// lib/features/student_affairs/presentation/screens/add_edit_student_screen.dart

import 'dart:io';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/core/widget/year_dropdown_form_field.dart'; // ✨ 1. استيراد الويدجت
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEditStudentScreen extends StatelessWidget {
  final Student? student;
  const AddEditStudentScreen({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageStudentCubit>(),
      child: _AddEditStudentView(student: student),
    );
  }
}

class _AddEditStudentView extends StatefulWidget {
  final Student? student;
  const _AddEditStudentView({this.student});

  @override
  State<_AddEditStudentView> createState() => _AddEditStudentViewState();
}

class _AddEditStudentViewState extends State<_AddEditStudentView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _universityIdController;
  late TextEditingController _motherNameController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _departmentController;
  late TextEditingController _gpaController;
  String? _selectedYear;
  DateTime? _selectedBirthDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  bool get _isEditMode => widget.student != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.student?.fullName ?? '',
    );
    _universityIdController = TextEditingController(
      text: widget.student?.universityId ?? '',
    );
    _motherNameController = TextEditingController(
      text: widget.student?.motherName ?? '',
    );
    _birthPlaceController = TextEditingController(
      text: widget.student?.birthPlace ?? '',
    );
    _departmentController = TextEditingController(
      text: widget.student?.department ?? '',
    );
    _gpaController = TextEditingController(
      text: widget.student?.highSchoolGpa.toString() ?? '',
    );

    if (_isEditMode) {
      _selectedYear = widget.student!.year;
    }

    _selectedBirthDate =
        widget.student != null
            ? DateTime.tryParse(widget.student!.birthDate)
            : null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityIdController.dispose();
    _motherNameController.dispose();
    _birthPlaceController.dispose();
    _departmentController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2002, 1, 1),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final studentData = {
        'full_name': _fullNameController.text,
        'university_id': _universityIdController.text,
        'mother_name': _motherNameController.text,
        'birth_date':
            _selectedBirthDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)
                : '',
        'birth_place': _birthPlaceController.text,
        'department': _departmentController.text,
        'year': _selectedYear ?? '',
        'high_school_gpa': _gpaController.text,
      };

      if (_isEditMode) {
        context.read<ManageStudentCubit>().updateStudent(
          id: widget.student!.id,
          studentData: studentData,
        );
      } else {
        context.read<ManageStudentCubit>().addStudent(
          studentData: studentData,
          image: _profileImage,
        );
      }
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد'),
      ),
      body: BlocListener<ManageStudentCubit, ManageStudentState>(
        listener: (context, state) async {
          if (state is ManageStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) Navigator.of(context).pop(true);
          } else if (state is ManageStudentFailure) {
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
            padding: const EdgeInsets.all(16.0),
            children: [
              if (!_isEditMode) ...[
                _buildImagePicker(),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: _validateField,
              ),
              TextFormField(
                controller: _universityIdController,
                decoration: const InputDecoration(labelText: 'الرقم الجامعي'),
                validator: _validateField,
              ),
              TextFormField(
                controller: _motherNameController,
                decoration: const InputDecoration(labelText: 'اسم الأم'),
                validator: _validateField,
              ),
              TextFormField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(labelText: 'مكان الولادة'),
                validator: _validateField,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'القسم'),
                validator: _validateField,
              ),
              const SizedBox(height: 16),
              // ✨ 2. استدعاء الويدجت الجديد هنا ✨
              YearDropdownFormField(
                selectedYear: _selectedYear,
                onChanged: (newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gpaController,
                decoration: const InputDecoration(labelText: 'معدل الثانوية'),
                keyboardType: TextInputType.number,
                validator: _validateField,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 24),
              BlocBuilder<ManageStudentCubit, ManageStudentState>(
                builder: (context, state) {
                  if (state is ManageStudentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ الطالب'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
            child:
                _profileImage == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return OutlinedButton.icon(
      onPressed: _pickDate,
      icon: const Icon(Icons.calendar_today),
      label: Text(
        _selectedBirthDate == null
            ? 'اختر تاريخ الميلاد'
            : DateFormat('dd / MM / yyyy').format(_selectedBirthDate!),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
