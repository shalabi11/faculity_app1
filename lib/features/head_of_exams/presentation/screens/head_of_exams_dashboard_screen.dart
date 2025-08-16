// lib/features/head_of_exams/presentation/screens/head_of_exams_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/cubit/head_of_exams_dashboard_cubit.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/exams_for_publishing_screen.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/head_of_exams_profile_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadOfExamsDashboardScreen extends StatelessWidget {
  final User user;
  const HeadOfExamsDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => di.sl<HeadOfExamsDashboardCubit>()..fetchDashboardData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('لوحة تحكم رئيس الامتحانات'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  tooltip: 'الملف الشخصي',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HeadOfExamsProfileScreen(user: user),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HeadOfExamsDashboardCubit>().fetchDashboardData();
              },
              child: BlocBuilder<
                HeadOfExamsDashboardCubit,
                HeadOfExamsDashboardState
              >(
                builder: (context, state) {
                  if (state is HeadOfExamsDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is HeadOfExamsDashboardFailure) {
                    return ErrorState(
                      message: state.message,
                      onRetry:
                          () =>
                              context
                                  .read<HeadOfExamsDashboardCubit>()
                                  .fetchDashboardData(),
                    );
                  }
                  if (state is HeadOfExamsDashboardSuccess) {
                    return _buildDashboardBody(context, state);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardBody(
    BuildContext context,
    HeadOfExamsDashboardSuccess state,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نظرة عامة على حالة الامتحانات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: _buildYearlyStatsChart(state.statsByYear),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'تحتاج إلى مراجعة ونشر',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ExamsForPublishingScreen(),
                  ),
                );
              },
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPublishableExamsByYear(context, state.publishableExams),
      ],
    );
  }

  // ✨ --- هذا هو الويدجت الذي تم تعديله بالكامل --- ✨
  Widget _buildYearlyStatsChart(Map<String, YearExamStats> stats) {
    final sortedYears = stats.keys.toList()..sort();

    // إيجاد أعلى قيمة في كل البيانات لتحديد المحور العمودي
    double maxY = 0;
    stats.values.forEach((stat) {
      if (stat.totalExams > maxY) maxY = stat.totalExams.toDouble();
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2, // أعلى قيمة + 20% مسافة فارغة
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String year = sortedYears[group.x.toInt()];
              String title = rodIndex == 0 ? 'الإجمالي' : 'جاهز للنشر';
              return BarTooltipItem(
                '$year\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '$title: ${rod.toY.toInt()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= sortedYears.length)
                  return const SizedBox();
                return Text(
                  sortedYears[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          // تفعيل المحور الأيسر وتنسيق الأرقام
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28, // مساحة كافية للأرقام
              interval: maxY > 10 ? 5 : 1, // تغيير الفاصل بناءً على القيم
              getTitlesWidget: (value, meta) {
                // عرض الأرقام كأعداد صحيحة فقط
                if (value % 1 != 0) return const SizedBox();
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            sortedYears.asMap().entries.map((entry) {
              final index = entry.key;
              final year = entry.value;
              final yearStats = stats[year]!;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: yearStats.totalExams.toDouble(),
                    color: Colors.blue.withOpacity(0.5),
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  BarChartRodData(
                    toY: yearStats.publishableExams.toDouble(),
                    color: Colors.green,
                    width: 15,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPublishableExamsByYear(
    BuildContext context,
    List<ExamEntity> exams,
  ) {
    if (exams.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.check_circle_outline, color: Colors.green),
          title: Text('لا توجد امتحانات جاهزة للنشر حالياً.'),
        ),
      );
    }

    final Map<String, List<ExamEntity>> examsByYear = {};
    for (var exam in exams) {
      final year = exam.targetYear ?? 'غير محدد';
      (examsByYear[year] ??= []).add(exam);
    }
    final sortedYears = examsByYear.keys.toList()..sort();

    return Column(
      children:
          sortedYears.map((year) {
            final yearExams = examsByYear[year]!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'السنة $year (${yearExams.length} امتحان)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                children:
                    yearExams.map((exam) {
                      return ListTile(
                        title: Text(exam.courseName),
                        subtitle: Text('تاريخ الامتحان: ${exam.examDate}'),
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }
}
