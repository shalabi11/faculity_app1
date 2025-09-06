// lib/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/core/widget/year_dropdown_form_field.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_dashboard_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_dashboard_state.dart';
// ✨ --- استيراد الشاشات المطلوبة --- ✨
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/all_students_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/create_student_account_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_profile_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_details_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/students_by_year_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAffairsDashboardScreen extends StatelessWidget {
  const StudentAffairsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              di.sl<StudentAffairsDashboardCubit>()..fetchDashboardData(),
      child: const _StudentAffairsDashboardView(),
    );
  }
}

class _StudentAffairsDashboardView extends StatelessWidget {
  const _StudentAffairsDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم شؤون الطلاب'),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return IconButton(
                  icon: const Icon(Icons.person_outline),
                  tooltip: 'الملف الشخصي',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                StudentAffairsProfileScreen(user: state.user),
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
        onRefresh: () async {
          context.read<StudentAffairsDashboardCubit>().fetchDashboardData();
        },
        child: BlocBuilder<
          StudentAffairsDashboardCubit,
          StudentAffairsDashboardState
        >(
          builder: (context, state) {
            if (state is StudentAffairsDashboardLoading) {
              return const Center(child: LoadingList());
            }
            if (state is StudentAffairsDashboardFailure) {
              return ErrorState(
                message: state.message,
                onRetry:
                    () =>
                        context
                            .read<StudentAffairsDashboardCubit>()
                            .fetchDashboardData(),
              );
            }
            if (state is StudentAffairsDashboardSuccess) {
              return _buildBody(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    StudentAffairsDashboardSuccess state,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _buildKpiCard(
          'إجمالي الطلاب المسجلين',
          state.totalStudents.toString(),
          Icons.groups_outlined,
          Colors.blue,
        ),
        const SizedBox(height: 24),
        // ✨ --- تم تغيير هذا الجزء بالكامل --- ✨
        _buildActionCard(
          'عرض وإدارة كل الطلاب',
          Icons.people_alt_outlined,
          Colors.teal,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AllStudentsScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'إجراءات الحسابات والبيانات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildActionCard(
              'إنشاء حساب طالب',
              Icons.person_add_alt_1,
              Colors.green,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateStudentAccountScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'إضافة بيانات طالب',
              Icons.note_add_outlined,
              Colors.orange,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStudentScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 16)),
              ],
            ),
            Icon(icon, size: 40, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
