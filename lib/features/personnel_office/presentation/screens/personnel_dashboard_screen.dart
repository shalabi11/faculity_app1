// lib/features/personnel_office/presentation/screens/personnel_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
// ✨ --- 1. استيراد شاشة إنشاء الحساب --- ✨
import 'package:faculity_app2/features/personnel_office/presentation/screens/create_user_account_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';
import 'package:faculity_app2/features/personnel_office/presentation/screens/personnel_profile_screen.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_state.dart';
import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/teacher_list_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonnelDashboardScreen extends StatelessWidget {
  const PersonnelDashboardScreen({super.key});

  void _refreshData(BuildContext context) {
    context.read<TeacherCubit>().fetchTeachers();
    context.read<StaffCubit>().fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<TeacherCubit>()..fetchTeachers(),
        ),
        BlocProvider(create: (context) => di.sl<StaffCubit>()..fetchStaff()),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('مكتب الذاتية'),
              centerTitle: true,
              backgroundColor: Colors.teal[700],
              actions: [
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return IconButton(
                        icon: const Icon(Icons.person_outline),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      PersonnelProfileScreen(user: state.user),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async => _refreshData(context),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        BlocBuilder<TeacherCubit, TeacherState>(
                          builder: (context, state) {
                            return _buildDashboardCard(
                              context: context,
                              title: 'قسم الدكاترة',
                              icon: Icons.school_outlined,
                              color: Colors.orange.shade700,
                              state: state,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TeacherListScreen(),
                                  ),
                                ).then((_) => _refreshData(context));
                              },
                            );
                          },
                        ),
                        BlocBuilder<StaffCubit, StaffState>(
                          builder: (context, state) {
                            return _buildDashboardCard(
                              context: context,
                              title: 'قسم الموظفين',
                              icon: Icons.people_alt_outlined,
                              color: Colors.blue.shade700,
                              state: state,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const StaffListScreen(),
                                  ),
                                ).then((_) => _refreshData(context));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // ✨ --- 2. إضافة قسم الإجراءات --- ✨
                    _buildActionsSection(context),
                    const SizedBox(height: 24),
                    _buildStatsChartCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✨ --- 3. ويدجت جديد لقسم الإجراءات --- ✨
  Widget _buildActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(Icons.person_add, color: Colors.green.shade700),
            title: const Text(
              'إنشاء حساب جديد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('إضافة دكتور أو موظف جديد إلى النظام'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateUserAccountScreen(),
                ),
              ).then((_) => _refreshData(context)); // تحديث عند العودة
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required dynamic state,
    required VoidCallback onTap,
  }) {
    String countText;
    if (state is TeacherSuccess) {
      countText = state.teachers.length.toString();
    } else if (state is StaffLoaded) {
      countText = state.staff.length.toString();
    } else if (state is TeacherLoading || state is StaffLoading) {
      countText = '...';
    } else {
      countText = 'خطأ';
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              countText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إحصائيات الموظفين',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: BlocBuilder<TeacherCubit, TeacherState>(
                builder: (context, teacherState) {
                  return BlocBuilder<StaffCubit, StaffState>(
                    builder: (context, staffState) {
                      if (teacherState is TeacherLoading ||
                          staffState is StaffLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (teacherState is TeacherSuccess &&
                          staffState is StaffLoaded) {
                        return _buildBarChart(
                          teacherCount: teacherState.teachers.length,
                          staffCount: staffState.staff.length,
                        );
                      }
                      return const Center(child: Text('فشل تحميل البيانات'));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart({required int teacherCount, required int staffCount}) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (teacherCount > staffCount ? teacherCount : staffCount) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, TitleMeta meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'الدكاترة';
                    break;
                  case 1:
                    text = 'الموظفين';
                    break;
                }
                return Text(text, style: const TextStyle(fontSize: 12));
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
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: teacherCount.toDouble(),
                color: Colors.orange.shade700,
                width: 22,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: staffCount.toDouble(),
                color: Colors.blue.shade700,
                width: 22,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
