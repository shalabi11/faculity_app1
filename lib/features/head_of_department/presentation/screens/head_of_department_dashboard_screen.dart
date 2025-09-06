// lib/features/head_of_department/presentation/screens/head_of_department_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/courses/presentation/screens/manage_course_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/manage_exams_screen.dart';
import 'package:faculity_app2/features/head_of_department/presentation/cubit/head_of_department_dashboard_cubit.dart';
import 'package:faculity_app2/features/head_of_department/presentation/screens/head_of_dapartment_profile_screen.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/manage_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadOfDepartmentDashboardScreen extends StatelessWidget {
  final User user;
  const HeadOfDepartmentDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // ✨ --- 1. التأكد من أن المستخدم لديه قسم --- ✨
    final String? department = user.department;

    if (department == null) {
      // حالة احترازية: إذا لم يتمكن التطبيق من جلب القسم
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(
          child: Text(
            'لم يتم تحديد القسم الخاص بك. يرجى تسجيل الخروج والمحاولة مرة أخرى.',
          ),
        ),
      );
    }

    return BlocProvider(
      // ✨ --- 2. تمرير القسم الفعلي للمستخدم إلى الـ Cubit --- ✨
      create:
          (context) =>
              di.sl<HeadOfDepartmentDashboardCubit>()
                ..fetchDashboardData(department),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('لوحة تحكم رئيس القسم'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  tooltip: 'الملف الشخصي',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => HeadOfDepartmentProfileScreen(user: user),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                // ✨ --- 3. استخدام القسم الفعلي عند تحديث الصفحة --- ✨
                context
                    .read<HeadOfDepartmentDashboardCubit>()
                    .fetchDashboardData(department);
              },
              child: BlocBuilder<
                HeadOfDepartmentDashboardCubit,
                HeadOfDepartmentDashboardState
              >(
                builder: (context, state) {
                  if (state is HeadOfDepartmentDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is HeadOfDepartmentDashboardFailure) {
                    return ErrorState(
                      message: state.message,
                      onRetry:
                          () => context
                              .read<HeadOfDepartmentDashboardCubit>()
                              .fetchDashboardData(department),
                    );
                  }
                  if (state is HeadOfDepartmentDashboardSuccess) {
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

  Widget _buildBody(
    BuildContext context,
    HeadOfDepartmentDashboardSuccess state,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        // قسم الإحصائيات
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                'المدرسون بالقسم',
                state.departmentTeachers.length.toString(),
                Icons.school_outlined,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _KpiCard(
                'المقررات بالقسم',
                state.departmentCourses.length.toString(),
                Icons.book_outlined,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // قسم قائمة المدرسين
        const Text(
          'مدرسو القسم',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child:
              state.departmentTeachers.isEmpty
                  ? const ListTile(title: Text('لا يوجد مدرسون في هذا القسم.'))
                  : Column(
                    children:
                        state.departmentTeachers
                            .map(
                              (teacher) => ListTile(
                                title: Text(teacher.fullName),
                                subtitle: Text(teacher.position),
                              ),
                            )
                            .toList(),
                  ),
        ),
        const SizedBox(height: 24),

        // قسم الإجراءات السريعة
        const Text(
          'إجراءات سريعة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          children: [
            _ActionCard(
              'إدارة المواد',
              Icons.book_outlined,
              () => _navigateTo(context, const ManageCoursesScreen()),
            ),
            _ActionCard(
              'عرض الجداول',
              Icons.schedule_outlined,
              () => _navigateTo(
                context,
                ManageSchedulesScreen(
                  appBar: AppBar(
                    title: const Text('إدارة الجداول الدراسية'),
                    // bottom: const TabBar(
                    //   tabs: [Tab(text: 'نظري'), Tab(text: 'عملي')],
                    // ),
                  ),
                ),
              ),
            ),
            _ActionCard(
              'عرض الامتحانات',
              Icons.assignment_outlined,
              () => _navigateTo(context, const ManageExamsScreen()),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

// ويدجت بطاقة الإحصائيات
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiCard(this.title, this.value, this.icon, this.color);

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

// ويدجت بطاقة الإجراءات السريعة
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionCard(this.title, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
