// lib/features/teachers/presentation/widgets/teacher_dashboard_widgets.dart

import 'dart:async';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- 1. ويدجت بطاقة الإحصائيات ---
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class UpcomingEventCard extends StatelessWidget {
  final ExamEntity? exam;
  final ScheduleEntity? nextLecture;

  const UpcomingEventCard({super.key, this.exam, this.nextLecture});

  @override
  Widget build(BuildContext context) {
    if (exam == null && nextLecture == null) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.check_circle_outline, color: Colors.green),
          title: Text("لا توجد أحداث قادمة."),
        ),
      );
    }

    // ✨ --- تم تعديل هذا الجزء ليكون أكثر أماناً --- ✨
    final bool isExam = (exam != null);
    final title =
        isExam ? exam!.courseName : (nextLecture?.courseName ?? 'غير متوفر');
    final icon =
        isExam ? Icons.edit_calendar_outlined : Icons.schedule_outlined;
    final label = isExam ? "الامتحان القادم" : "المحاضرة التالية";
    final time =
        isExam
            ? exam!.examDate
            : (nextLecture != null
                ? '${nextLecture?.day} - ${nextLecture?.startTime}'
                : 'غير متوفر');

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(label, style: const TextStyle(fontSize: 12)),
        subtitle: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: Text(time),
      ),
    );
  }
}

// --- 3. ويدجت مخطط العبء الأسبوعي ---
class WeeklyWorkloadChart extends StatelessWidget {
  final List<ScheduleEntity> schedule;
  const WeeklyWorkloadChart({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> dailyCounts = {
      'الأحد': 0,
      'الإثنين': 0,
      'الثلاثاء': 0,
      'الأربعاء': 0,
      'الخميس': 0,
    };
    for (var entry in schedule) {
      if (dailyCounts.containsKey(entry.day)) {
        dailyCounts[entry.day] = dailyCounts[entry.day]! + 1;
      }
    }

    return SizedBox(
      height: 150,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(fontSize: 10);
                  String text = '';
                  switch (value.toInt()) {
                    case 0:
                      text = 'الأحد';
                      break;
                    case 1:
                      text = 'الإثنين';
                      break;
                    case 2:
                      text = 'الثلاثاء';
                      break;
                    case 3:
                      text = 'الأربعاء';
                      break;
                    case 4:
                      text = 'الخميس';
                      break;
                  }
                  // ✨ --- هذا هو السطر الذي تم تصحيحه --- ✨
                  // نقوم بإرجاع ويدجت Text مباشرة
                  return Text(text, style: style);
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups:
              dailyCounts.entries
                  .map((e) {
                    int index = [
                      'الأحد',
                      'الإثنين',
                      'الثلاثاء',
                      'الأربعاء',
                      'الخميس',
                    ].indexOf(e.key);
                    if (index == -1) return null;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.toDouble(),
                          color: AppColors.primary,
                          width: 15,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  })
                  .whereType<BarChartGroupData>()
                  .toList(),
        ),
      ),
    );
  }
}
