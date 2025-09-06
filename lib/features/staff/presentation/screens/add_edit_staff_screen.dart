// lib/features/staff/presentation/screens/add_edit_staff_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEditStaffScreen extends StatefulWidget {
  final StaffEntity? staff;
  final Map<String, dynamic>? initialData;

  const AddEditStaffScreen({super.key, this.staff, this.initialData});

  @override
  State<AddEditStaffScreen> createState() => _AddEditStaffScreenState();
}

class _AddEditStaffScreenState extends State<AddEditStaffScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _academicDegreeController = TextEditingController();
  final _departmentController = TextEditingController();
  final _employmentDateController = TextEditingController();

  int? _userId;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _userId = widget.initialData!['user_id'];
      _fullNameController.text = widget.initialData!['name'] ?? '';
      _departmentController.text = _mapDepartment(
        widget.initialData!['department'],
      );
    } else if (widget.staff != null) {
      _userId = widget.staff!.userId;
      _fullNameController.text = widget.staff!.fullName;
      _motherNameController.text = widget.staff!.motherName;
      _birthDateController.text = widget.staff!.birthDate;
      _birthPlaceController.text = widget.staff!.birthPlace;
      _academicDegreeController.text = widget.staff!.academicDegree;
      _departmentController.text = widget.staff!.department;
      _employmentDateController.text = widget.staff!.employmentDate;
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
        return code ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _motherNameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _academicDegreeController.dispose();
    _departmentController.dispose();
    _employmentDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveStaff() {
    if (_formKey.currentState!.validate()) {
      final staffData = {
        // ✨ التأكد من إرسال user_id
        'user_id': _userId.toString(),
        'full_name': _fullNameController.text.trim(),
        'mother_name': _motherNameController.text.trim(),
        'birth_date': _birthDateController.text.trim(),
        'birth_place': _birthPlaceController.text.trim(),
        'academic_degree': _academicDegreeController.text.trim(),
        'department': _departmentController.text.trim(),
        'employment_date': _employmentDateController.text.trim(),
      };
      if (widget.staff == null) {
        context.read<ManageStaffCubit>().addStaff(staffData);
      } else {
        context.read<ManageStaffCubit>().updateStaff(
          widget.staff!.id,
          staffData,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageStaffCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.staff == null ? 'إضافة بيانات موظف' : 'تعديل بيانات موظف',
          ),
        ),
        body: BlocConsumer<ManageStaffCubit, ManageStaffState>(
          listener: (context, state) {
            if (state is ManageStaffSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.toString()),
                  backgroundColor: Colors.green,
                ),
              );
              int count = 0;
              Navigator.of(context).popUntil(
                (_) => count++ >= (widget.initialData != null ? 2 : 1),
              );
            } else if (state is ManageStaffFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل العملية: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ManageStaffLoading;
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
                    _buildDateField(
                      context,
                      _birthDateController,
                      'تاريخ الميلاد',
                    ),
                    _buildTextField(
                      controller: _birthPlaceController,
                      label: 'مكان الولادة',
                    ),
                    _buildTextField(
                      controller: _academicDegreeController,
                      label: 'الدرجة العلمية',
                    ),
                    _buildTextField(
                      controller: _departmentController,
                      label: 'القسم',
                      readOnly: widget.initialData != null,
                    ),
                    _buildDateField(
                      context,
                      _employmentDateController,
                      'تاريخ التوظيف',
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveStaff,
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

  Widget _buildDateField(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        onTap: () => _selectDate(context, controller),
        validator:
            (value) =>
                (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }
}
