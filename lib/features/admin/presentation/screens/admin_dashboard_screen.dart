// lib/features/admin/presentation/screens/admin_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_profile_screen.dart';
import 'package:faculity_app2/features/admin/presentation/screens/manage_announcements_screen.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/screens/distribute_halls_screen.dart';
import 'package:faculity_app2/features/classrooms/presentation/screens/manage_classrooms_screen.dart';
import 'package:faculity_app2/features/courses/presentation/screens/manage_course_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/manage_exams_screen.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/manage_schedule_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/manage_student_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/manage_teachers_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardScreen extends StatelessWidget {
  final User user;
  const AdminDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AdminDashboardCubit>()..fetchDashboardData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('لوحة تحكم المسؤول'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdminProfileScreen(user: user),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<AdminDashboardCubit>().fetchDashboardData();
              },
              child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
                builder: (context, state) {
                  if (state is AdminDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AdminDashboardFailure) {
                    return ErrorState(
                      message: state.message,
                      onRetry:
                          () =>
                              context
                                  .read<AdminDashboardCubit>()
                                  .fetchDashboardData(),
                    );
                  }
                  if (state is AdminDashboardSuccess) {
                    return _buildBody(context, state);
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

  Widget _buildBody(BuildContext context, AdminDashboardSuccess state) {
    // ... (بقية الكود يبقى كما هو)
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'إدارة الطلاب',
        icon: Icons.people_outline,
        onTap: () => _navigateTo(context, const ManageStudentsScreen()),
      ),
      DashboardItem(
        title: 'إدارة المدرسين',
        icon: Icons.school_outlined,
        onTap: () => _navigateTo(context, const ManageTeachersScreen()),
      ),
      DashboardItem(
        title: 'إدارة المواد',
        icon: Icons.book_outlined,
        onTap: () => _navigateTo(context, const ManageCoursesScreen()),
      ),
      DashboardItem(
        title: 'إدارة القاعات',
        icon: Icons.meeting_room_outlined,
        onTap: () => _navigateTo(context, const ManageClassroomsScreen()),
      ),
      DashboardItem(
        title: 'إدارة الجداول',
        icon: Icons.schedule_outlined,
        onTap: () => _navigateTo(context, const ManageSchedulesScreen()),
      ),
      DashboardItem(
        title: 'إدارة الامتحانات',
        icon: Icons.assignment_outlined,
        onTap: () => _navigateTo(context, const ManageExamsScreen()),
      ),
      DashboardItem(
        title: 'إدارة الإعلانات',
        icon: Icons.campaign_outlined,
        onTap: () => _navigateTo(context, const ManageAnnouncementsScreen()),
      ),
      DashboardItem(
        title: 'توزيع القاعات',
        icon: Icons.grid_on_outlined,
        onTap: () => _navigateTo(context, const DistributeHallsScreen()),
      ),
    ];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          children: [
            _KpiCard(
              'الطلاب',
              state.studentCount.toString(),
              Icons.people_outline,
              Colors.blue,
            ),
            _KpiCard(
              'المدرسون',
              state.teacherCount.toString(),
              Icons.school_outlined,
              Colors.orange,
            ),
            _KpiCard(
              'المقررات',
              state.courseCount.toString(),
              Icons.book_outlined,
              Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'توزيع الطلاب على السنوات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  // ✨ --- 1. استبدال المخطط الدائري بالمخطط الشريطي --- ✨
                  child: _StudentDistributionBarChart(
                    studentsByYear: state.studentsByYear,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'الإجراءات الإدارية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _ActionCard(item: items[index]);
          },
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

// (بقية الويدجتس تبقى كما هي)
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// ✨ --- 2. ويدجت جديد للمخطط الشريطي --- ✨
class _StudentDistributionBarChart extends StatelessWidget {
  final Map<String, int> studentsByYear;
  const _StudentDistributionBarChart({required this.studentsByYear});

  @override
  Widget build(BuildContext context) {
    final sortedYears = studentsByYear.keys.toList()..sort();
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: true),
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
            sortedYears.asMap().entries.map((entry) {
              final index = entry.key;
              final year = entry.value;
              final count = studentsByYear[year]!;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: count.toDouble(),
                    color: colors[index % colors.length],
                    width: 22,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final DashboardItem item;
  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  DashboardItem({required this.title, required this.icon, required this.onTap});
}
