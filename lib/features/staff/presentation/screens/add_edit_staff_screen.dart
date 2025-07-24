import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_state.dart';

class AddEditStaffScreen extends StatelessWidget {
  final StaffEntity? staffMember;
  const AddEditStaffScreen({super.key, this.staffMember});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageStaffCubit>(),
      child: _AddEditStaffView(staffMember: staffMember),
    );
  }
}

class _AddEditStaffView extends StatefulWidget {
  final StaffEntity? staffMember;
  const _AddEditStaffView({this.staffMember});

  @override
  State<_AddEditStaffView> createState() => _AddEditStaffViewState();
}

class _AddEditStaffViewState extends State<_AddEditStaffView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _departmentController;
  late TextEditingController _academicDegreeController;
  late TextEditingController _birthPlaceController;
  DateTime? _selectedBirthDate;
  DateTime? _selectedEmploymentDate;

  bool get isEditMode => widget.staffMember != null;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.staffMember?.fullName ?? '',
    );
    _motherNameController = TextEditingController(
      text: widget.staffMember?.motherName ?? '',
    );
    _departmentController = TextEditingController(
      text: widget.staffMember?.department ?? '',
    );
    _academicDegreeController = TextEditingController(
      text: widget.staffMember?.academicDegree ?? '',
    );
    _birthPlaceController = TextEditingController(
      text: widget.staffMember?.birthPlace ?? '',
    );
    _selectedBirthDate =
        widget.staffMember != null
            ? DateTime.tryParse(widget.staffMember!.birthDate)
            : null;
    _selectedEmploymentDate =
        widget.staffMember != null
            ? DateTime.tryParse(widget.staffMember!.employmentDate)
            : null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _motherNameController.dispose();
    _departmentController.dispose();
    _academicDegreeController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // التحقق من صحة النموذج والتواريخ
    if (_formKey.currentState!.validate() &&
        (_selectedBirthDate != null && _selectedEmploymentDate != null)) {
      final staffData = {
        'full_name': _fullNameController.text,
        'mother_name': _motherNameController.text,
        'birth_place': _birthPlaceController.text,
        'department': _departmentController.text,
        'academic_degree': _academicDegreeController.text,
        'birth_date': _selectedBirthDate!.toIso8601String().substring(0, 10),
        'employment_date': _selectedEmploymentDate!.toIso8601String().substring(
          0,
          10,
        ),
      };
      if (isEditMode) {
        context.read<ManageStaffCubit>().updateStaff(
          widget.staffMember!.id,
          staffData,
        );
      } else {
        context.read<ManageStaffCubit>().addStaff(staffData);
      }
    } else {
      // إظهار رسالة إذا كانت التواريخ غير محددة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول واختيار التواريخ'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _pickDate(bool isBirthDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isBirthDate) {
          _selectedBirthDate = pickedDate;
        } else {
          _selectedEmploymentDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'تعديل بيانات الموظف' : 'إضافة موظف جديد'),
      ),
      body: BlocListener<ManageStaffCubit, ManageStaffState>(
        listener: (context, state) {
          if (state is ManageStaffSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت العملية بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ManageStaffFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
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
                TextFormField(
                  controller: _birthPlaceController,
                  decoration: const InputDecoration(labelText: 'مكان الولادة'),
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
                  controller: _academicDegreeController,
                  decoration: const InputDecoration(
                    labelText: 'الشهادة العلمية',
                  ),
                  validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  context,
                  'تاريخ الميلاد',
                  _selectedBirthDate,
                  () => _pickDate(true),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(
                  context,
                  'تاريخ التوظيف',
                  _selectedEmploymentDate,
                  () => _pickDate(false),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ManageStaffCubit, ManageStaffState>(
                  builder: (context, state) {
                    if (state is ManageStaffLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(isEditMode ? 'حفظ التعديلات' : 'حفظ الموظف'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? date,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              date != null
                  ? '${date.year}/${date.month}/${date.day}'
                  : 'اختر تاريخاً',
            ),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
