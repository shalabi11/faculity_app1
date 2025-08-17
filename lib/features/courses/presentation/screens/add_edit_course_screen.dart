// lib/features/courses/presentation/screens/add_edit_course_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
// ✨ 1. استيراد الويدجت الجديد
import 'package:faculity_app2/core/widget/year_dropdown_form_field.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/manage_course_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditCourseScreen extends StatelessWidget {
  final CourseEntity? course;
  const AddEditCourseScreen({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ManageCourseCubit>(),
      child: _AddEditCourseView(course: course),
    );
  }
}

class _AddEditCourseView extends StatefulWidget {
  final CourseEntity? course;
  const _AddEditCourseView({this.course});

  @override
  State<_AddEditCourseView> createState() => _AddEditCourseViewState();
}

class _AddEditCourseViewState extends State<_AddEditCourseView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _departmentController;
  String? _selectedYear;

  bool get _isEditMode => widget.course != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.course?.name ?? '');
    _departmentController = TextEditingController(
      text: widget.course?.department ?? '',
    );
    if (_isEditMode) {
      _selectedYear = widget.course!.year;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final courseData = {
        'name': _nameController.text,
        'department': _departmentController.text,
        'year': _selectedYear,
      };

      if (_isEditMode) {
        context.read<ManageCourseCubit>().updateCourse(
          id: widget.course!.id,
          courseData: courseData,
        );
      } else {
        context.read<ManageCourseCubit>().addCourse(courseData: courseData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل المادة' : 'إضافة مادة جديدة'),
      ),
      body: BlocListener<ManageCourseCubit, ManageCourseState>(
        listener: (context, state) {
          if (state is ManageCourseSuccess) {
            Navigator.pop(context, true);
          } else if (state is ManageCourseFailure) {
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
                decoration: const InputDecoration(labelText: 'اسم المادة'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'القسم'),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),

              // ✨ --- 2. استدعاء الويدجت الجديد هنا --- ✨
              YearDropdownFormField(
                selectedYear: _selectedYear,
                onChanged: (newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<ManageCourseCubit, ManageCourseState>(
                builder: (context, state) {
                  if (state is ManageCourseLoading) {
                    return const Center(child: LoadingList());
                  }
                  return ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ المادة'),
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
