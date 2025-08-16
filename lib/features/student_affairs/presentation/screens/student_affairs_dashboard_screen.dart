// lib/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/core/widget/year_dropdown_form_field.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_dashboard_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_profile_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_details_screen.dart';
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

class _StudentAffairsDashboardView extends StatefulWidget {
  const _StudentAffairsDashboardView();

  @override
  State<_StudentAffairsDashboardView> createState() =>
      __StudentAffairsDashboardViewState();
}

class __StudentAffairsDashboardViewState
    extends State<_StudentAffairsDashboardView> {
  String? _selectedYear;

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
              return const Center(child: CircularProgressIndicator());
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
              // ✨ --- هذا هو السطر الذي تم تصحيحه --- ✨
              // أضفنا List<Student> بشكل صريح
              final List<Student> filteredStudents =
                  _selectedYear == null
                      ? []
                      : state.studentsByYear[_selectedYear] ?? [];

              return _buildBody(context, state, filteredStudents);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (context) => di.sl<ManageStudentCubit>(),
                    child: const AddEditStudentScreen(),
                  ),
            ),
          );
          if (result == true && context.mounted) {
            context.read<StudentAffairsDashboardCubit>().fetchDashboardData();
          }
        },
        tooltip: 'إضافة طالب جديد',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    StudentAffairsDashboardSuccess state,
    List<Student> filteredStudents,
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
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'عرض طلاب سنة معينة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                YearDropdownFormField(
                  selectedYear: _selectedYear,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedYear = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 32),
        if (_selectedYear != null)
          _buildFilteredStudentsList(context, filteredStudents),
      ],
    );
  }

  Widget _buildFilteredStudentsList(
    BuildContext context,
    List<Student> students,
  ) {
    if (students.isEmpty) {
      return const Center(child: Text('لا يوجد طلاب مسجلون في هذه السنة.'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                student.fullName.isNotEmpty ? student.fullName[0] : '',
              ),
            ),
            title: Text(student.fullName),
            subtitle: Text('الرقم الجامعي: ${student.universityId}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentDetailsScreen(student: student),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
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
