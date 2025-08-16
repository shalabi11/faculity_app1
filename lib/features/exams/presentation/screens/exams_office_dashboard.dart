// lib/features/exams/presentation/screens/exams_office_dashboard.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/screens/distribute_halls_screen.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exams_dashboard_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/screens/add_edit_exam_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exam_result_screen.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exams_office_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamsOfficeDashboardScreen extends StatelessWidget {
  const ExamsOfficeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ExamsDashboardCubit>()..fetchDashboardData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('مكتب الامتحانات'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.grading_outlined),
                  tooltip: 'إدخال العلامات',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ExamSelectionForResultsScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.grid_on_outlined),
                  tooltip: 'توزيع القاعات',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const DistributeHallsScreen(),
                      ),
                    );
                  },
                ),
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
                                  (_) => ExamsOfficeProfileScreen(
                                    user: state.user,
                                  ),
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
                context.read<ExamsDashboardCubit>().fetchDashboardData();
              },
              child: BlocBuilder<ExamsDashboardCubit, ExamsDashboardState>(
                builder: (context, state) {
                  if (state is ExamsDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ExamsDashboardFailure) {
                    return ErrorState(
                      message: state.message,
                      onRetry:
                          () =>
                              context
                                  .read<ExamsDashboardCubit>()
                                  .fetchDashboardData(),
                    );
                  }
                  if (state is ExamsDashboardSuccess) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildSectionHeader(
                          context,
                          'امتحانات مجدولة',
                          state.scheduledExams.length,
                        ),
                        // ✨ 1. استدعاء الويدجت الجديد
                        _buildScheduledExamsByYear(
                          context,
                          state.scheduledExams,
                        ),
                        const SizedBox(height: 24),
                        // Slider(value: 1, onChanged: (value) {}, divisions: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(
                            thickness: 2, // سماكة الخط
                            height:
                                20, // الارتفاع الكلي (يشمل المسافة فوق وتحت الخط)
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          context,
                          'مواد بانتظار الجدولة',
                          state.unscheduledCourses.length,
                        ),

                        _buildUnscheduledCoursesByYear(
                          context,
                          state.unscheduledCourses,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEditExamScreen()),
                ).then((success) {
                  if (success == true) {
                    context.read<ExamsDashboardCubit>().fetchDashboardData();
                  }
                });
              },
              child: const Icon(Icons.add),
              tooltip: 'إضافة امتحان جديد',
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(width: 8),
          CircleAvatar(radius: 12, child: Text(count.toString())),
        ],
      ),
    );
  }

  // ✨ --- 3. ويدجت جديد لعرض الامتحانات المجدولة حسب السنة --- ✨
  Widget _buildScheduledExamsByYear(
    BuildContext context,
    List<ExamEntity> exams,
  ) {
    if (exams.isEmpty) {
      return const Card(
        child: ListTile(title: Text('لا توجد امتحانات مجدولة حالياً.')),
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
              elevation: 2,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'السنة $year',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                children:
                    yearExams.map((exam) {
                      return ListTile(
                        title: Text(exam.courseName),
                        subtitle: Text('التاريخ: ${exam.examDate}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditExamScreen(exam: exam),
                            ),
                          ).then((success) {
                            if (success == true) {
                              context
                                  .read<ExamsDashboardCubit>()
                                  .fetchDashboardData();
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }

  // ✨ --- 4. ويدجت جديد لعرض المواد غير المجدولة حسب السنة --- ✨
  Widget _buildUnscheduledCoursesByYear(
    BuildContext context,
    List<CourseEntity> courses,
  ) {
    if (courses.isEmpty) {
      return const Card(
        child: ListTile(title: Text('جميع المواد تم جدولتها.')),
      );
    }

    final Map<String, List<CourseEntity>> coursesByYear = {};
    for (var course in courses) {
      (coursesByYear[course.year] ??= []).add(course);
    }
    final sortedYears = coursesByYear.keys.toList()..sort();

    return Column(
      children:
          sortedYears.map((year) {
            final yearCourses = coursesByYear[year]!;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2,
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'السنة $year',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                children:
                    yearCourses.map((course) {
                      return ListTile(
                        title: Text(course.name),
                        subtitle: Text('القسم: ${course.department}'),
                        trailing: const Icon(Icons.add_circle_outline),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddEditExamScreen(),
                            ),
                          ).then((success) {
                            if (success == true) {
                              context
                                  .read<ExamsDashboardCubit>()
                                  .fetchDashboardData();
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }
}
