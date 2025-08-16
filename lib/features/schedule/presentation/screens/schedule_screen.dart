import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_state.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/add_edit_schedule_screen.dart';

class ScheduleScreen extends StatelessWidget {
  final String scheduleType;
  final String identifier;
  final String? section;

  const ScheduleScreen({
    super.key,
    required this.scheduleType,
    required this.identifier,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = di.sl<ScheduleCubit>();
            _fetchInitialData(cubit);
            return cubit;
          },
        ),
        BlocProvider(create: (context) => di.sl<ManageScheduleCubit>()),
      ],
      child: Scaffold(
        // لا داعي لوضع AppBar هنا لأنه موجود في الشاشة الأم
        body: BlocListener<ManageScheduleCubit, ManageScheduleState>(
          listener: (context, state) {
            if (state is ManageScheduleSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // بعد نجاح أي عملية، قم بتحديث القائمة
              _fetchInitialData(context.read<ScheduleCubit>());
            } else if (state is ManageScheduleFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(child: LoadingList());
              } else if (state is ScheduleSuccess) {
                return _buildScheduleView(context, state.schedule);
              } else if (state is ScheduleFailure) {
                return Center(child: Text('فشل: ${state.message}'));
              }
              return const Center(child: Text('جاري التحميل...'));
            },
          ),
        ),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () => _navigateToAddEditScreen(context),
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }

  void _fetchInitialData(ScheduleCubit cubit) {
    if (scheduleType == 'theory') {
      cubit.fetchTheorySchedule(year: identifier);
    } else {
      cubit.fetchLabSchedule(group: identifier, section: section ?? '');
    }
  }

  void _navigateToAddEditScreen(
    BuildContext context, {
    ScheduleEntity? schedule,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScheduleScreen(schedule: schedule),
      ),
    ).then((result) {
      if (result == true) {
        _fetchInitialData(context.read<ScheduleCubit>());
      }
    });
  }

  Widget _buildScheduleView(
    BuildContext context,
    List<ScheduleEntity> scheduleList,
  ) {
    final Map<String, List<ScheduleEntity>> scheduleByDay = {};
    for (var schedule in scheduleList) {
      (scheduleByDay[schedule.day] ??= []).add(schedule);
    }
    final days =
        ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس']
            .where(
              (day) =>
                  scheduleByDay.containsKey(day) &&
                  scheduleByDay[day]!.isNotEmpty,
            )
            .toList();

    if (days.isEmpty)
      return const Center(child: Text('لا يوجد بيانات لعرضها.'));

    return RefreshIndicator(
      onRefresh: () async => _fetchInitialData(context.read<ScheduleCubit>()),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final schedulesForDay = scheduleByDay[day]!;
          return _buildDayCard(context, day, schedulesForDay);
        },
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    String day,
    List<ScheduleEntity> schedules,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          day,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
        children:
            schedules
                .map((schedule) => _buildScheduleTile(context, schedule))
                .toList(),
      ),
    );
  }

  Widget _buildScheduleTile(BuildContext context, ScheduleEntity schedule) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            schedule.courseName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text('الدكتور: ${schedule.teacherName}'),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('القاعة: ${schedule.classroomName}'),
              Text('الوقت: ${schedule.startTime} - ${schedule.endTime}'),
            ],
          ),
          // --- أزرار التعديل والحذف ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
                onPressed:
                    () => _navigateToAddEditScreen(context, schedule: schedule),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text(
                            'هل أنت متأكد من رغبتك في حذف هذه الجلسة؟',
                          ),
                          actions: [
                            TextButton(
                              child: const Text('إلغاء'),
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('حذف'),
                              onPressed: () {
                                context
                                    .read<ManageScheduleCubit>()
                                    .deleteSchedule(id: schedule.id);
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
