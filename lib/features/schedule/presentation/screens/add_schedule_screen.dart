// lib/features/admin/presentation/screens/add_schedule_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/custom_dropdown_form_field.dart';
import 'package:faculity_app2/core/widget/custom_text_field.dart';
import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_cubit.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_state.dart';
import 'package:faculity_app2/features/courses/domain/entities/course.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_cubit.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddScheduleScreen extends StatelessWidget {
  const AddScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ManageScheduleCubit>()),
        BlocProvider(create: (context) => sl<CourseCubit>()..fetchCourses()),
        BlocProvider(create: (context) => sl<TeacherCubit>()..fetchTeachers()),
        BlocProvider(
          create: (context) => sl<ClassroomCubit>()..fetchClassrooms(),
        ),
      ],
      child: const _AddScheduleView(),
    );
  }
}

class _AddScheduleView extends StatefulWidget {
  const _AddScheduleView();

  @override
  State<_AddScheduleView> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<_AddScheduleView> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedCourseId;
  int? _selectedTeacherId;
  int? _selectedClassroomId;
  String? _selectedDay;
  String? _selectedType;
  String? _selectedYear;
  String? _selectedGroup;

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
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
                  use24hFormat: true,
                  onDateTimeChanged:
                      (DateTime newTime) => selectedTime = newTime,
                ),
              ),
              TextButton(
                onPressed: () {
                  final formattedTime = DateFormat(
                    'HH:mm',
                  ).format(selectedTime);
                  setState(() => controller.text = formattedTime);
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
      final scheduleData = {
        'course_id': _selectedCourseId.toString(),
        'teacher_id': _selectedTeacherId.toString(),
        'classroom_id': _selectedClassroomId.toString(),
        'day': _selectedDay,
        'start_time': _startTimeController.text,
        'end_time': _endTimeController.text,
        'type': _selectedType,
        'year': _selectedYear,
        'group': _selectedGroup,
      };
      context.read<ManageScheduleCubit>().addSchedule(
        scheduleData: scheduleData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة محاضرة جديدة')),
      body: BlocListener<ManageScheduleCubit, ManageScheduleState>(
        listener: (context, state) {
          if (state is ManageScheduleSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ManageScheduleFailure) {
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
              _buildCoursesDropdown(),
              const SizedBox(height: 16),
              _buildTeachersDropdown(),
              const SizedBox(height: 16),
              _buildClassroomsDropdown(),
              const SizedBox(height: 16),
              _buildDaysDropdown(),
              const SizedBox(height: 16),
              _buildTypesDropdown(),
              const SizedBox(height: 16),
              _buildYearsDropdown(),
              const SizedBox(height: 16),
              _buildGroupsDropdown(),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _startTimeController,
                labelText: 'وقت البدء',
                icon: Icons.access_time_outlined,
                readOnly: true,
                onTap: () => _selectTime(_startTimeController),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _endTimeController,
                labelText: 'وقت الانتهاء',
                icon: Icons.access_time_filled_outlined,
                readOnly: true,
                onTap: () => _selectTime(_endTimeController),
              ),
              const SizedBox(height: 24),
              BlocBuilder<ManageScheduleCubit, ManageScheduleState>(
                builder: (context, state) {
                  if (state is ManageScheduleLoading)
                    return const Center(child: CircularProgressIndicator());
                  return ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('حفظ المحاضرة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  // --- دوال بناء القوائم المنسدلة باستخدام الويدجت المخصص الجديد ---

  Widget _buildCoursesDropdown() {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseSuccess) {
          return CustomDropdownFormField<int>(
            value: _selectedCourseId,
            labelText: 'المادة الدراسية',
            icon: Icons.book_outlined,
            items:
                state.courses
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _selectedCourseId = v),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTeachersDropdown() {
    return BlocBuilder<TeacherCubit, TeacherState>(
      builder: (context, state) {
        if (state is TeacherSuccess) {
          return CustomDropdownFormField<int>(
            value: _selectedTeacherId,
            labelText: 'المدرس',
            icon: Icons.person_outline,
            items:
                state.teachers
                    .map(
                      (t) => DropdownMenuItem<int>(
                        value: t.id,
                        child: Text(t.fullName),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _selectedTeacherId = v),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildClassroomsDropdown() {
    return BlocBuilder<ClassroomCubit, ClassroomState>(
      builder: (context, state) {
        if (state is ClassroomSuccess) {
          return CustomDropdownFormField<int>(
            value: _selectedClassroomId,
            labelText: 'القاعة الدراسية',
            icon: Icons.meeting_room_outlined,
            items:
                state.classrooms
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.name),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => _selectedClassroomId = v),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildDaysDropdown() {
    final days = {
      'السبت': 'Saturday',
      'الأحد': 'Sunday',
      'الاثنين': 'Monday',
      'الثلاثاء': 'Tuesday',
      'الأربعاء': 'Wednesday',
      'الخميس': 'Thursday',
      'الجمعة': 'Friday',
    };
    return CustomDropdownFormField<String>(
      value: _selectedDay,
      labelText: 'اليوم',
      icon: Icons.calendar_month_outlined,
      items:
          days.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _selectedDay = v),
    );
  }

  Widget _buildTypesDropdown() {
    return CustomDropdownFormField<String>(
      value: _selectedType,
      labelText: 'نوع المحاضرة',
      icon: Icons.computer_outlined,
      items: const [
        DropdownMenuItem(value: 'theory', child: Text('نظري')),
        DropdownMenuItem(value: 'lab', child: Text('عملي')),
      ],
      onChanged: (v) => setState(() => _selectedType = v),
    );
  }

  Widget _buildYearsDropdown() {
    final years = {
      'الأولى': 'first',
      'الثانية': 'second',
      'الثالثة': 'third',
      'الرابعة': 'fourth',
      'الخامسة': 'fifth',
    };
    return CustomDropdownFormField<String>(
      value: _selectedYear,
      labelText: 'السنة الدراسية',
      icon: Icons.school_outlined,
      items:
          years.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                ),
              )
              .toList(),
      onChanged: (v) => setState(() => _selectedYear = v),
    );
  }

  Widget _buildGroupsDropdown() {
    final groups = ['A', 'B'];
    return CustomDropdownFormField<String>(
      value: _selectedGroup,
      labelText: 'المجموعة',
      icon: Icons.group_outlined,
      items:
          groups
              .map(
                (String group) =>
                    DropdownMenuItem<String>(value: group, child: Text(group)),
              )
              .toList(),
      onChanged: (v) => setState(() => _selectedGroup = v),
    );
  }
}
