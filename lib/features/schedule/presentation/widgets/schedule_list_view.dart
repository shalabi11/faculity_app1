import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/presentation/widgets/schedule_card.dart';

import 'package:flutter/material.dart';

class ScheduleListView extends StatelessWidget {
  final List<ScheduleEntry> entries;
  const ScheduleListView({
    super.key,
    required this.entries,
    required List<ScheduleEntry> schedule,
  });

  @override
  Widget build(BuildContext context) {
    // يمكننا لاحقًا تجميع الجدول حسب الأيام هنا
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ScheduleCard(entry: entry);
      },
    );
  }
}
