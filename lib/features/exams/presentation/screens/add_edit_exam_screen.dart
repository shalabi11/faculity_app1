// lib/features/exams/presentation/screens/add_edit_exam_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
// ✨ 1. استيراد الويدجت الجديد
import 'package:faculity_app2/core/widget/year_dropdown_form_field.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/manage_exam_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEditExamScreen extends StatelessWidget {
  final ExamEntity? exam;
  const AddEditExamScreen({super.key, this.exam});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ManageExamCubit>()),
        BlocProvider(create: (context) => di.sl<CourseCubit>()..fetchCourses()),
      ],
      child: _AddEditExamView(exam: exam),
    );
  }
}

class _AddEditExamView extends StatefulWidget {
  final ExamEntity? exam;
  const _AddEditExamView({this.exam});

  @override
  State<_AddEditExamView> createState() => _AddEditExamViewState();
}

class _AddEditExamViewState extends State<_AddEditExamView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  int? _selectedCourseId;
  String? _selectedType;
  // ✨ 2. تحويل متغير السنة إلى متغير عادي
  String? _selectedYear;

  bool get _isEditMode => widget.exam != null;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: _isEditMode ? widget.exam!.examDate : '',
    );
    _startTimeController = TextEditingController(
      text: widget.exam?.startTime ?? '',
    );
    _endTimeController = TextEditingController(
      text: widget.exam?.endTime ?? '',
    );

    if (_isEditMode) {
      _selectedCourseId = widget.exam!.courseId;
      _selectedType = widget.exam!.type;
      _selectedYear = widget.exam!.targetYear;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _isEditMode && _dateController.text.isNotEmpty
              ? DateTime.tryParse(_dateController.text) ?? DateTime.now()
              : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    DateTime selectedTime = DateTime.now();
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newTime) {
                    selectedTime = newTime;
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  final formattedTime = DateFormat(
                    'HH:mm',
                  ).format(selectedTime);
                  setState(() {
                    controller.text = formattedTime;
                  });
                  Navigator.pop(context);
                },
                child: const Text('تم'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final examData = {
        'course_id': _selectedCourseId.toString(),
        'exam_date': _dateController.text,
        'start_time': _startTimeController.text,
        'end_time': _endTimeController.text,
        'type': _selectedType,
        // ✨ 3. استخدام القيمة الجديدة للسنة
        'target_year': _selectedYear,
      };

      if (_isEditMode) {
        context.read<ManageExamCubit>().updateExam(
          id: widget.exam!.id,
          examData: examData,
        );
      } else {
        context.read<ManageExamCubit>().addExam(examData: examData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'تعديل الامتحان' : 'إضافة امتحان جديد'),
      ),
      body: BlocListener<ManageExamCubit, ManageExamState>(
        listener: (context, state) {
          if (state is ManageExamSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ManageExamFailure) {
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
              _buildCourseDropdown(),
              const SizedBox(height: 16),
              // ✨ --- 4. استدعاء الويدجت الجديد هنا --- ✨
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
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'تاريخ الامتحان',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: 'وقت البدء',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(_startTimeController),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'وقت الانتهاء',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(_endTimeController),
                validator: (v) => v!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              _buildTypeDropdown(),
              const SizedBox(height: 24),
              BlocBuilder<ManageExamCubit, ManageExamState>(
                builder: (context, state) {
                  if (state is ManageExamLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ الامتحان'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDropdown() {
    // ... (This function remains unchanged)
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoaded) {
          final isValueValid = state.courses.any(
            (course) => course.id == _selectedCourseId,
          );
          return DropdownButtonFormField<int>(
            value: isValueValid ? _selectedCourseId : null,
            hint: const Text('اختر المادة الدراسية'),
            items:
                state.courses.map((CourseEntity course) {
                  return DropdownMenuItem<int>(
                    value: course.id,
                    child: Text(course.name),
                  );
                }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedCourseId = newValue;
              });
            },
            validator: (value) => value == null ? 'الرجاء اختيار مادة' : null,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTypeDropdown() {
    // ... (This function remains unchanged)
    return DropdownButtonFormField<String>(
      value: _selectedType,
      hint: const Text('اختر نوع الامتحان'),
      items: const [
        DropdownMenuItem<String>(value: 'فصل اول ', child: Text('فصل اول ')),
        DropdownMenuItem<String>(value: 'فصل ثاني', child: Text('فصل ثاني')),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedType = newValue;
        });
      },
      validator: (value) => value == null ? 'الرجاء اختيار نوع الامتحان' : null,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
