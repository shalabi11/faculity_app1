// lib/features/admin/presentation/screens/manage_schedules_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/add_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSchedulesScreen extends StatelessWidget {
  const ManageSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ScheduleCubit>(),
      child: DefaultTabController(
        length: 2, // لدينا تبويبان: نظري وعملي
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إدارة الجداول الدراسية'),
            bottom: const TabBar(tabs: [Tab(text: 'نظري'), Tab(text: 'عملي')]),
          ),
          body: const TabBarView(
            children: [
              // واجهة عرض الجدول النظري
              _ScheduleView(isTheory: true),
              // واجهة عرض الجدول العملي
              _ScheduleView(isTheory: false),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const AddScheduleScreen()),
              );
              // عند العودة بنجاح، قم بتحديث الجدول المعروض حاليًا
              if (result == true) {
                // This is a simple way to trigger a refresh.
                // A more advanced way would be to check which tab is active
                // and refresh only that one. For now, this is fine.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت الإضافة. أعد البحث لترى التغييرات.'),
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

// ويدجت داخلي لعرض محتوى كل تبويب
class _ScheduleView extends StatefulWidget {
  final bool isTheory;
  const _ScheduleView({required this.isTheory});

  @override
  State<_ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<_ScheduleView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchSchedule() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال قيمة في الحقل'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.isTheory) {
      context.read<ScheduleCubit>().fetchTheorySchedule(year: _controller.text);
    } else {
      context.read<ScheduleCubit>().fetchLabSchedule(group: _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText:
                        widget.isTheory
                            ? 'أدخل السنة (e.g., first)'
                            : 'أدخل المجموعة (e.g., A)',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _fetchSchedule,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                child: const Text('عرض الجدول'),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(child: CircularProgressIndicator());
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
                return ListView.builder(
                  itemCount: state.schedule.length,
                  itemBuilder: (context, index) {
                    final entry = state.schedule[index];
                    return _ScheduleCard(entry: entry);
                  },
                );
              }
              return const Center(child: Text('الرجاء إدخال قيمة والبحث.'));
            },
          ),
        ),
      ],
    );
  }
}

// بطاقة لعرض كل محاضرة في الجدول
class _ScheduleCard extends StatelessWidget {
  final ScheduleEntry entry;
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
