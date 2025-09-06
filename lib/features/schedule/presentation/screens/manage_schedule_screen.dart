// lib/features/schedule/presentation/screens/manage_schedule_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/add_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSchedulesScreen extends StatelessWidget {
  const ManageSchedulesScreen({super.key, required this.appBar});
  final AppBar appBar;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: const TabBarView(
          children: [
            _ScheduleView(isTheory: true),
            _ScheduleView(isTheory: false),
          ],
        ),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () async {
                  await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const AddScheduleScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  final bool isTheory;
  const _ScheduleView({required this.isTheory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ScheduleCubit>(),
      child: _ScheduleViewContent(isTheory: isTheory),
    );
  }
}

class _ScheduleViewContent extends StatefulWidget {
  final bool isTheory;
  const _ScheduleViewContent({required this.isTheory});

  @override
  State<_ScheduleViewContent> createState() => _ScheduleViewContentState();
}

class _ScheduleViewContentState extends State<_ScheduleViewContent> {
  String? _selectedValue;

  void _fetchSchedule(BuildContext context, String value) {
    if (widget.isTheory) {
      context.read<ScheduleCubit>().fetchTheorySchedule(year: value);
    } else {
      context.read<ScheduleCubit>().fetchLabSchedule(
        group: value,
        section: 'A',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = {
      'الأولى': 'first',
      'الثانية': 'second',
      'الثالثة': 'third',
      'الرابعة': 'fourth',
      'الخامسة': 'fifth',
    };
    final groups = ['A', 'B'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DropdownButtonFormField<String>(
            value: _selectedValue,
            hint: Text(widget.isTheory ? 'اختر السنة' : 'اختر المجموعة'),
            isExpanded: true,
            items:
                (widget.isTheory
                        ? years.entries.map(
                          (e) => DropdownMenuItem(
                            value: e.value,
                            child: Text(e.key),
                          ),
                        )
                        : groups.map(
                          (g) => DropdownMenuItem(
                            value: g,
                            child: Text('المجموعة $g'),
                          ),
                        ))
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedValue = value;
                });
                _fetchSchedule(context, value);
              }
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        Expanded(
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(child: LoadingList());
              }
              if (state is ScheduleFailure) {
                return Center(child: Text('خطأ: ${state.message}'));
              }
              if (state is ScheduleSuccess) {
                if (state.schedule.isEmpty) {
                  return const Center(
                    child: Text('لا توجد محاضرات في هذا الجدول.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    if (_selectedValue != null) {
                      _fetchSchedule(context, _selectedValue!);
                    }
                  },
                  child: ListView.builder(
                    itemCount: state.schedule.length,
                    itemBuilder: (context, index) {
                      final entry = state.schedule[index];
                      return _ScheduleCard(entry: entry);
                    },
                  ),
                );
              }
              return const Center(
                child: Text('الرجاء اختيار قيمة لعرض الجدول.'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final ScheduleEntity entry;
  const _ScheduleCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.courseName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('المدرس: ${entry.teacherName}'),
            const SizedBox(height: 4),
            Text('القاعة: ${entry.classroomName}'),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('اليوم: ${entry.day}'),
                Text('الوقت: ${entry.startTime} - ${entry.endTime}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
