// lib/features/student_affairs/presentation/screens/add_student_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ✨ استيراد ضروري لتنسيق التاريخ

class AddStudentScreen extends StatelessWidget {
  final Map<String, dynamic>? initialData;

  const AddStudentScreen({super.key, this.initialData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageStudentCubit>(),
      child: _AddStudentForm(initialData: initialData),
    );
  }
}

class _AddStudentForm extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const _AddStudentForm({this.initialData});

  @override
  State<_AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<_AddStudentForm> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _departmentController = TextEditingController();
  final _gpaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _fullNameController.text = widget.initialData!['name'] ?? '';
      _universityIdController.text = widget.initialData!['university_id'] ?? '';
      _departmentController.text = _mapDepartment(
        widget.initialData!['department'],
      );
    }
  }

  String _mapDepartment(String? code) {
    switch (code) {
      case 'SE':
        return 'هندسة البرمجيات';
      case 'AI':
        return 'الذكاء الصنعي';
      case 'NE':
        return 'الشبكات';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityIdController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _departmentController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  // ✨ --- 1. دالة لفتح منتقي التاريخ --- ✨
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980), // تاريخ بداية معقول
      lastDate: DateTime.now(), // لا يمكن اختيار تاريخ في المستقبل
    );
    if (picked != null) {
      setState(() {
        // تنسيق التاريخ بالشكل المطلوب (YYYY-MM-DD)
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveStudentData() {
    if (_formKey.currentState!.validate()) {
      final studentData = {
        'full_name': _fullNameController.text.trim(),
        'university_id': _universityIdController.text.trim(),
        'mother_name': _motherNameController.text.trim(),
        'birth_date': _birthDateController.text.trim(),
        'birth_place': _birthPlaceController.text.trim(),
        'department': _departmentController.text.trim(),
        'high_school_gpa': _gpaController.text.trim(),
      };
      context.read<ManageStudentCubit>().addStudent(studentData: studentData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إكمال بيانات الطالب')),
      body: BlocConsumer<ManageStudentCubit, ManageStudentState>(
        listener: (context, state) {
          if (state is ManageStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت إضافة بيانات الطالب بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          } else if (state is ManageStudentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل إضافة البيانات: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ManageStudentLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'الاسم الكامل',
                    readOnly: widget.initialData != null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _universityIdController,
                    label: 'الرقم الجامعي',
                    readOnly: widget.initialData != null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _motherNameController,
                    label: 'اسم الأم',
                  ),
                  const SizedBox(height: 16),
                  // ✨ --- 2. تعديل حقل تاريخ الميلاد --- ✨
                  TextFormField(
                    controller: _birthDateController,
                    readOnly: true, // جعله للقراءة فقط لمنع الكتابة اليدوية
                    decoration: const InputDecoration(
                      labelText: 'تاريخ الميلاد',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context), // فتح التقويم عند الضغط
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'هذا الحقل مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _birthPlaceController,
                    label: 'مكان الولادة',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _departmentController,
                    label: 'القسم',
                    readOnly: widget.initialData != null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _gpaController,
                    label: 'معدل الثانوية',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveStudentData,

                    child:
                        isLoading
                            ? const LoadingList(
                              // color: Colors.white,
                            )
                            : const Text('حفظ وإنهاء'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        fillColor: readOnly ? Colors.grey.shade200 : null,
        filled: readOnly,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}
