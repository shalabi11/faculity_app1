// lib/features/schedule/presentation/widgets/schedule_list_view.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

// الحفاظ على اسم الكلاس الأصلي ومتغيراته
class ScheduleListView extends StatelessWidget {
  final String scheduleType;
  final String? year;
  final String? section;

  const ScheduleListView({
    super.key,
    required this.scheduleType,
    this.year,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    // التحقق من وجود البيانات المطلوبة قبل بناء الـ Cubit
    if ((scheduleType == 'theory' && year == null) ||
        (scheduleType == 'lab' && section == null)) {
      return const _EmptyState(
        message: 'المعلومات المطلوبة (السنة أو الفئة) غير متوفرة في حسابك.',
      );
    }

    return BlocProvider(
      create: (context) {
        final cubit = sl<ScheduleCubit>();
        // استخدام نفس منطق الدوال الموجودة لديك
        if (scheduleType == 'theory') {
          cubit.fetchTheorySchedule(year: year!);
        } else {
          cubit.fetchLabSchedule(section: section!, group: '');
        }
        return cubit;
      },
      // ويدجت داخلي لعرض الواجهة، للحفاظ على نظافة الكود
      child: _ScheduleViewContent(
        scheduleType: scheduleType,
        year: year,
        section: section,
      ),
    );
  }
}

class _ScheduleViewContent extends StatelessWidget {
  final String scheduleType;
  final String? year;
  final String? section;
  const _ScheduleViewContent({
    required this.scheduleType,
    this.year,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام BlocBuilder لمراقبة الحالات وإعادة بناء الواجهة
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        // ---- معالجة حالات عرض البيانات ----

        // 1. حالة التحميل
        if (state is ScheduleLoading) {
          return const _LoadingList();
        }
        // 2. حالة الفشل
        if (state is ScheduleFailure) {
          return _ErrorState(
            message: state.message,
            onRetry: () {
              final cubit = context.read<ScheduleCubit>();
              if (scheduleType == 'theory') {
                cubit.fetchTheorySchedule(year: year!);
              } else {
                cubit.fetchLabSchedule(section: section!, group: '');
              }
            },
          );
        }
        // 3. حالة النجاح
        if (state is ScheduleSuccess) {
          // 3.1. التأكد من أن القائمة ليست فارغة
          if (state.schedule.isEmpty) {
            return const _EmptyState(
              message: 'لا توجد محاضرات في هذا الجدول حالياً.',
            );
          }
          // 3.2. عرض القائمة في حال وجود بيانات
          return RefreshIndicator(
            onRefresh: () async {
              final cubit = context.read<ScheduleCubit>();
              if (scheduleType == 'theory') {
                cubit.fetchTheorySchedule(year: year!);
              } else {
                cubit.fetchLabSchedule(section: section!, group: '');
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.schedule.length,
              itemBuilder: (context, index) {
                final scheduleItem = state.schedule[index];
                // استخدام بطاقة العرض الجديدة مع تأثير حركة
                return _ScheduleCard(schedule: scheduleItem)
                    .animate()
                    .fade(delay: (100 * index).ms, duration: 400.ms)
                    .slideX(begin: -0.3, duration: 400.ms);
              },
            ),
          );
        }
        // الحالة الافتراضية (عادةً تكون حالة التحميل الأولية)
        return const _LoadingList();
      },
    );
  }
}

// --- ويدجتس الواجهة (UI Widgets) ---

// بطاقة عرض المحاضرة بتصميم احترافي
class _ScheduleCard extends StatelessWidget {
  final ScheduleEntity schedule;
  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  schedule.startTime,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('..', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  schedule.endTime,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
            const VerticalDivider(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.courseName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.person_outline,
                    text: schedule.teacherName,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: 'القاعة: ${schedule.classroomName}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت لعرض سطر من المعلومات
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

// واجهة التحميل (Shimmer)
class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder:
            (context, index) => const Card(
              margin: EdgeInsets.only(bottom: 16),
              child: SizedBox(height: 120),
            ),
      ),
    );
  }
}

// واجهة عرض في حال كانت القائمة فارغة
class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    ).animate().fade();
  }
}

// واجهة عرض في حال حدوث خطأ
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text('حدث خطأ ما', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    ).animate().fade();
  }
}
