// lib/features/main_screen/presentation/widgets/home_screen_widgets.dart

import 'dart:async';
import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- 1. ويدجت مخطط نظرة على أسبوعك ---
class WeeklyScheduleChart extends StatelessWidget {
  final List<ScheduleEntity> schedule;
  const WeeklyScheduleChart({super.key, required this.schedule});

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
                  // نقوم بتمرير كائن meta بالكامل كما هو مطلوب
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(text, style: style),
                  );
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
                    if (index == -1) return null; // تجاهل الأيام غير الموجودة
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
                  .toList(), // فلترة القيم الفارغة
        ),
      ),
    );
  }
}

// --- 2. ويدجت عداد الامتحان التنازلي ---
class ExamCountdownWidget extends StatefulWidget {
  final ExamEntity exam;
  const ExamCountdownWidget({super.key, required this.exam});

  @override
  State<ExamCountdownWidget> createState() => _ExamCountdownWidgetState();
}

class _ExamCountdownWidgetState extends State<ExamCountdownWidget> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeRemaining();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    try {
      final examDate = DateTime.parse(widget.exam.examDate);
      final now = DateTime.now();
      final remaining = examDate.difference(now);
      if (mounted) {
        setState(() {
          _timeRemaining =
              remaining > Duration.zero ? remaining : Duration.zero;
        });
      }
    } catch (e) {
      // Handle invalid date format
      if (mounted) {
        setState(() {
          _timeRemaining = Duration.zero;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;

    return Card(
      elevation: 0,
      color: AppColors.primary.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.school_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  widget.exam.courseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountdownUnit(days.toString(), 'أيام'),
                _buildCountdownUnit(hours.toString(), 'ساعات'),
                _buildCountdownUnit(minutes.toString(), 'دقائق'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

// --- 3. ويدجت مخطط أداء العلامات ---
class GradesPerformanceChart extends StatelessWidget {
  final List<ExamResultEntity> results;
  const GradesPerformanceChart({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    // أخذ آخر 5 نتائج فقط وعكسها لعرضها بالشكل الصحيح
    final recentResults = results.take(5).toList().reversed.toList();

    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false), // إخفاء المحاور للتبسيط
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (recentResults.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots:
                  recentResults.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.score ?? 0);
                  }).toList(),
              isCurved: true,
              color: AppColors.success,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.success.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
