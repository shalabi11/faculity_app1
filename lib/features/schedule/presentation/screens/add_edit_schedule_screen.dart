import 'dart:developer';

import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_state.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_form_data_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_form_data_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;

class AddEditScheduleScreen extends StatelessWidget {
  final ScheduleEntity? schedule;
  const AddEditScheduleScreen({super.key, this.schedule});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<ManageScheduleCubit>()),
        BlocProvider(
          create: (context) => di.sl<ScheduleFormDataCubit>()..fetchFormData(),
        ),
      ],
      child: _AddEditScheduleView(schedule: schedule),
    );
  }
}

class _AddEditScheduleView extends StatefulWidget {
  final ScheduleEntity? schedule;
  const _AddEditScheduleView({this.schedule});

  @override
  State<_AddEditScheduleView> createState() => _AddEditScheduleViewState();
}

class _AddEditScheduleViewState extends State<_AddEditScheduleView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCourseId;
  String? _selectedTeacherId;
  String? _selectedClassroomId;
  String? _selectedDay;
  String? _scheduleType;
  String? _year;
  String? _group;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool get isEditMode => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // ملاحظة: بما أننا لا نملك ID للمقرر والدكتور، سنتركها فارغة حالياً
      // يجب تحديث الـ Entity والـ Model ليشمل هذه البيانات
      _selectedCourseId = null;
      _selectedTeacherId = null;
      _selectedClassroomId = null;
      _selectedDay = widget.schedule!.day;
      _scheduleType = widget.schedule!.type;
      _year = widget.schedule!.year;
      _group = widget.schedule!.group;
      _startTime = TimeOfDay(
        hour: int.parse(widget.schedule!.startTime.split(':')[0]),
        minute: int.parse(widget.schedule!.startTime.split(':')[1]),
      );
      _endTime = TimeOfDay(
        hour: int.parse(widget.schedule!.endTime.split(':')[0]),
        minute: int.parse(widget.schedule!.endTime.split(':')[1]),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _startTime != null &&
        _endTime != null) {
      String formatTimeOfDay(TimeOfDay tod) {
        final now = DateTime.now();
        final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
        return DateFormat('HH:mm').format(dt);
      }

      final scheduleData = {
        'course_id': _selectedCourseId,
        'teacher_id': _selectedTeacherId,
        'classroom_id': _selectedClassroomId,
        'day': _selectedDay,
        'start_time': formatTimeOfDay(_startTime!),
        'end_time': formatTimeOfDay(_endTime!),
        'type': _scheduleType,
        'year': _year,
        'group': _group,
      };

      scheduleData.removeWhere((key, value) => value == null);

      if (isEditMode) {
        context.read<ManageScheduleCubit>().updateSchedule(
          id: widget.schedule!.id,
          scheduleData: scheduleData,
        );
      } else {
        context.read<ManageScheduleCubit>().addSchedule(
          scheduleData: scheduleData,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة جلسة جديدة')),
      // استخدام BlocBuilder للاستماع لحالة جلب بيانات النموذج
      body: BlocBuilder<ScheduleFormDataCubit, ScheduleFormDataState>(
        builder: (context, state) {
          if (state is ScheduleFormDataLoading) {
            log('loading');
            return const Center(child: LoadingList());
          } else if (state is ScheduleFormDataFailure) {
            log('failure');

            return Center(child: Text(state.message));
          } else if (state is ScheduleFormDataLoaded) {
            log('succes');

            // عند نجاح جلب البيانات، قم ببناء النموذج
            return _buildForm(context, state);
          }
          return const Center(child: Text('جاري تحميل بيانات النموذج...'));
        },
      ),
    );
  }

  // ويدجت خاصة لبناء النموذج بعد جلب البيانات
  Widget _buildForm(BuildContext context, ScheduleFormDataLoaded formData) {
    return BlocListener<ManageScheduleCubit, ManageScheduleState>(
      listener: (context, state) {
        if (state is ManageScheduleSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ManageScheduleFailure) {
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
              DropdownButtonFormField<String>(
                value: _selectedCourseId,
                decoration: const InputDecoration(
                  labelText: 'المقرر الدراسي',
                  border: OutlineInputBorder(),
                ),
                items:
                    formData.courses.map((course) {
                      return DropdownMenuItem(
                        value: course.id.toString(),
                        child: Text(course.name),
                      );
                    }).toList(),
                onChanged: (value) => setState(() => _selectedCourseId = value),
                validator: (v) => v == null ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTeacherId,
                decoration: const InputDecoration(
                  labelText: 'الدكتور',
                  border: OutlineInputBorder(),
                ),
                items:
                    formData.teachers.map((teacher) {
                      return DropdownMenuItem(
                        value: teacher.id.toString(),
                        child: Text(teacher.fullName),
                      );
                    }).toList(),
                onChanged:
                    (value) => setState(() => _selectedTeacherId = value),
                validator: (v) => v == null ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              // ملاحظة: قائمة القاعات الدراسية تحتاج إلى إضافتها بنفس الطريقة
              DropdownButtonFormField<String>(
                value: _selectedClassroomId,
                decoration: const InputDecoration(
                  labelText: 'القاعة الدراسية',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: '1',
                    child: Text('مدرج 1 (بيانات مؤقتة)'),
                  ),
                ],
                onChanged:
                    (value) => setState(() => _selectedClassroomId = value),
                validator: (v) => v == null ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(
                  labelText: 'اليوم',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس']
                        .map(
                          (day) =>
                              DropdownMenuItem(value: day, child: Text(day)),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedDay = value),
                validator: (v) => v == null ? 'الحقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              _buildTimePicker(context, 'وقت البدء', _startTime, (newTime) {
                setState(() => _startTime = newTime);
              }),
              const SizedBox(height: 16),
              _buildTimePicker(context, 'وقت الانتهاء', _endTime, (newTime) {
                setState(() => _endTime = newTime);
              }),
              const SizedBox(height: 24),
              BlocBuilder<ManageScheduleCubit, ManageScheduleState>(
                builder: (context, state) {
                  if (state is ManageScheduleLoading) {
                    return const Center(child: LoadingList());
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: _submitForm,
                    child: const Text('حفظ الجلسة'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    TimeOfDay? time,
    Function(TimeOfDay) onTimeChanged,
  ) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (pickedTime != null && pickedTime != time) {
          onTimeChanged(pickedTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              time?.format(context) ?? 'اختر وقتاً',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
