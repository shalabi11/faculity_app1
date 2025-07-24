import 'dart:io';
import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/add_student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedYear;

  // Controllers for each form field
  final _fullNameController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _departmentController = TextEditingController();
  final _yearController = TextEditingController();
  final _gpaController = TextEditingController();

  DateTime? _selectedBirthDate;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _fullNameController.dispose();
    _universityIdController.dispose();
    _motherNameController.dispose();
    _birthPlaceController.dispose();
    _departmentController.dispose();
    _yearController.dispose();
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
      initialDate: DateTime(2002, 1, 1),
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
      if (_selectedBirthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار تاريخ الميلاد'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final newStudent = StudentModel(
        id: 0, // Server will assign ID
        fullName: _fullNameController.text,
        universityId: _universityIdController.text,
        motherName: _motherNameController.text,
        birthDate: DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
        birthPlace: _birthPlaceController.text,
        department: _departmentController.text,
        year: _yearController.text,
        highSchoolGpa: double.tryParse(_gpaController.text) ?? 0.0,
      );

      context.read<AddStudentCubit>().createStudent(newStudent, _profileImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة طالب جديد'), centerTitle: true),
      body: BlocListener<AddStudentCubit, AddStudentState>(
        listener: (context, state) {
          if (state is AddStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تمت إضافة الطالب بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            // العودة للشاشة السابقة وتحديث قائمة الطلاب
            Navigator.of(context).pop(true);
          } else if (state is AddStudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
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
                _buildImagePicker(),
                const SizedBox(height: 16),
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
                // أضف هذا الكود بدلاً منه
                DropdownButtonFormField<String>(
                  value: _selectedYear,
                  decoration: const InputDecoration(
                    labelText: 'السنة الدراسية',
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  hint: const Text('اختر السنة'),
                  isExpanded: true,
                  items:
                      ['الاولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة']
                          .map(
                            (label) => DropdownMenuItem(
                              value: label,
                              child: Text(
                                'السنة ${(label)}',
                              ), // لعرض اسم السنة باللغة العربية
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                  validator:
                      (value) => value == null ? 'يرجى اختيار السنة' : null,
                ),
                TextFormField(
                  controller: _gpaController,
                  decoration: const InputDecoration(labelText: 'معدل الثانوية'),
                  keyboardType: TextInputType.number,
                  validator: _validateField,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 24),
                BlocBuilder<AddStudentCubit, AddStudentState>(
                  builder: (context, state) {
                    if (state is AddStudentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save),
                      label: const Text('حفظ الطالب'),
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
      ),
    );
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final student = StudentModel(
        id: 0, // Server will assign ID
        fullName: _fullNameController.text,
        universityId: _universityIdController.text,
        motherName: _motherNameController.text,
        birthDate: DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
        birthPlace: _birthPlaceController.text,
        department: _departmentController.text,
        year: _yearController.text,
        highSchoolGpa: double.tryParse(_gpaController.text) ?? 0.0,
      );
      context.read<AddStudentCubit>().addStudentUseCase(
        student as AddStudentParams,
      );
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
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
