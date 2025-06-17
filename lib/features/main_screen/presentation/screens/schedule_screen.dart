import 'package:collection/collection.dart';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleScreen extends StatelessWidget {
  final User user;
  final TabController tabController;

  const ScheduleScreen({
    super.key,
    required this.user,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _ScheduleTabView(scheduleType: ScheduleType.theory, user: user),
        _ScheduleTabView(scheduleType: ScheduleType.lab, user: user),
      ],
    );
  }
}

// ===============================================
//  ويدجت عرض محتوى كل تبويب
// ===============================================
enum ScheduleType { theory, lab }

class _ScheduleTabView extends StatefulWidget {
  final ScheduleType scheduleType;
  final User user;
  const _ScheduleTabView({required this.scheduleType, required this.user});

  @override
  State<_ScheduleTabView> createState() => _ScheduleTabViewState();
}

class _ScheduleTabViewState extends State<_ScheduleTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // للحفاظ على حالة التبويب عند التنقل

  // دالة لجلب البيانات بناءً على نوع التبويب
  Future<void> _fetchData() {
    final cubit = context.read<ScheduleCubit>();
    if (widget.scheduleType == ScheduleType.theory) {
      return cubit.fetchTheorySchedule(widget.user.year ?? '');
    } else {
      return cubit.fetchLabSchedule(widget.user.section ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) {
        final cubit = sl<ScheduleCubit>();
        if (widget.scheduleType == ScheduleType.theory) {
          cubit.fetchTheorySchedule(widget.user.year ?? '');
        } else {
          cubit.fetchLabSchedule(widget.user.section ?? '');
        }
        return cubit;
      },
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const _ScheduleLoadingWidget();
          }
          if (state is ScheduleError) {
            return Center(child: Text(state.message));
          }
          if (state is ScheduleLoaded) {
            if (state.schedule.isEmpty) {
              return const Center(child: Text('لا يوجد جدول لعرضه'));
            }
            final groupedByDay = groupBy(
              state.schedule,
              (ScheduleEntry entry) => entry.day,
            );
            final sortedDays =
                groupedByDay.keys.toList()
                  ..sort((a, b) => _dayOrder(a).compareTo(_dayOrder(b)));

            return RefreshIndicator(
              onRefresh: _fetchData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: sortedDays
                    .map((day) {
                      final entries = groupedByDay[day]!;
                      return _ScheduleDayCard(day: day, entries: entries);
                    })
                    .toList()
                    .animate(interval: 100.ms)
                    .fade(duration: 300.ms)
                    .slideY(
                      begin: 0.2,
                      duration: 300.ms,
                      curve: Curves.easeOut,
                    ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// دالة مساعدة لترتيب أيام الأسبوع
int _dayOrder(String day) {
  switch (day) {
    case 'الأحد':
      return 1;
    case 'الإثنين':
      return 2;
    case 'الثلاثاء':
      return 3;
    case 'الأربعاء':
      return 4;
    case 'الخميس':
      return 5;
    case 'الجمعة':
      return 6;
    case 'السبت':
      return 7;
    default:
      return 8;
  }
}

// ===============================================
//  ويدجت عرض بطاقة اليوم الواحد
// ===============================================
class _ScheduleDayCard extends StatelessWidget {
  final String day;
  final List<ScheduleEntry> entries;
  const _ScheduleDayCard({required this.day, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(day, style: Theme.of(context).textTheme.titleMedium),
        initiallyExpanded:
            day == _getTodayInArabic(), // فتح يوم اليوم الحالي تلقائيًا
        childrenPadding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        children: entries.map((entry) => _ScheduleEntryTile(entry)).toList(),
      ),
    );
  }
}

// دالة مساعدة لمعرفة اسم اليوم الحالي بالعربية
String _getTodayInArabic() {
  final dayOfWeek = DateTime.now().weekday;
  switch (dayOfWeek) {
    case DateTime.saturday:
      return 'السبت';
    case DateTime.sunday:
      return 'الأحد';
    case DateTime.monday:
      return 'الإثنين';
    case DateTime.tuesday:
      return 'الثلاثاء';
    case DateTime.wednesday:
      return 'الأربعاء';
    case DateTime.thursday:
      return 'الخميس';
    case DateTime.friday:
      return 'الجمعة';
    default:
      return '';
  }
}

// ===============================================
//  ويدجت عرض محاضرة واحدة
// ===============================================
class _ScheduleEntryTile extends StatelessWidget {
  final ScheduleEntry entry;
  const _ScheduleEntryTile(this.entry);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          Icons.menu_book_outlined,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          entry.courseName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${entry.teacherName} - ${entry.classroomName}"),
        trailing: Text(
          '${entry.startTime} - ${entry.endTime}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

// ===============================================
//  ويدجت حالة التحميل
// ===============================================
class _ScheduleLoadingWidget extends StatelessWidget {
  const _ScheduleLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const ShimmerContainer(height: 20, width: 120),
                  const SizedBox(height: 10),
                  const ShimmerContainer(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
