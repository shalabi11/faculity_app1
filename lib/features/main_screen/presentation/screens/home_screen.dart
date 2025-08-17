// lib/features/main_screen/presentation/screens/home_screen.dart

import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:faculity_app2/features/announcements/presentation/screens/announcements_list_screen.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';
import 'package:faculity_app2/features/main_screen/presentation/widget/home_screen_widgets.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar', null);
  }

  void _refreshData(BuildContext context) {
    context.read<ScheduleCubit>().fetchStudentWeeklySchedule(
      year: widget.user.year,
      section: widget.user.section,
    );
    context.read<StudentExamResultsCubit>().fetchStudentResults(
      studentId: widget.user.id,
    );
    context.read<AnnouncementCubit>().fetchAnnouncements();
    context.read<ExamCubit>().fetchExams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    _WelcomeHeader(
                      userName: widget.user.name,
                    ).animate().fade(duration: 400.ms),
                    const SizedBox(height: 24),

                    // --- ✨ تم تعديل هذا الجزء بالكامل --- ✨

                    // قسم نظرة على أسبوعك
                    _buildSectionTitle(context, "نظرة على أسبوعك"),
                    BlocBuilder<ScheduleCubit, ScheduleState>(
                      builder: (context, state) {
                        if (state is ScheduleLoading) {
                          return const SizedBox(
                            height: 150,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is ScheduleFailure) {
                          return ErrorState(
                            message: state.message,
                            onRetry: () => _refreshData(context),
                          );
                        }
                        if (state is ScheduleSuccess) {
                          if (state.schedule.isEmpty) {
                            return const Text("لا يوجد محاضرات في جدولك.");
                          }
                          return WeeklyScheduleChart(schedule: state.schedule);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),

                    // قسم الامتحان القادم
                    _buildSectionTitle(context, "الامتحان القادم"),
                    BlocBuilder<ExamCubit, ExamState>(
                      builder: (context, state) {
                        if (state is ExamLoading) {
                          return const SizedBox(
                            height: 150,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is ExamError) {
                          return ErrorState(
                            message: state.message,
                            onRetry: () => _refreshData(context),
                          );
                        }
                        if (state is ExamLoaded) {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final upcomingExams =
                              state.exams.where((exam) {
                                try {
                                  final examDate = DateTime.parse(
                                    exam.examDate,
                                  );
                                  return !examDate.isBefore(today);
                                } catch (e) {
                                  return false;
                                }
                              }).toList();
                          if (upcomingExams.isEmpty) {
                            return const Text("لا يوجد امتحانات قادمة.");
                          }
                          upcomingExams.sort(
                            (a, b) => DateTime.parse(
                              a.examDate,
                            ).compareTo(DateTime.parse(b.examDate)),
                          );
                          return ExamCountdownWidget(exam: upcomingExams.first);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),

                    // قسم أداء العلامات
                    _buildSectionTitle(context, "أداء العلامات"),
                    BlocBuilder<
                      StudentExamResultsCubit,
                      StudentExamResultsState
                    >(
                      builder: (context, state) {
                        if (state is StudentExamResultsLoading) {
                          return const SizedBox(
                            height: 150,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (state is StudentExamResultsFailure) {
                          return ErrorState(
                            message: state.message,
                            onRetry: () => _refreshData(context),
                          );
                        }
                        if (state is StudentExamResultsSuccess) {
                          if (state.results.isEmpty) {
                            return const Text("لم تصدر أي نتائج بعد.");
                          }
                          return GradesPerformanceChart(results: state.results);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),

                    _RecentAnnouncementsSection(),
                  ]
                  .animate(interval: 100.ms)
                  .fade(duration: 400.ms)
                  .slideY(begin: 0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required BlocBase cubit,
    required Widget Function(dynamic state) builder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        // ✨ --- تم تعديل هذا الجزء بالكامل --- ✨
        // استخدمنا BlocBuilder لضمان التعامل مع كل الحالات بشكل صحيح
        BlocBuilder(
          bloc: cubit as Bloc<dynamic, dynamic>,
          builder: (context, state) {
            // التحقق من نوع الحالة لتجنب الأخطاء
            if (cubit is ScheduleCubit && state is ScheduleLoading ||
                cubit is ExamCubit && state is ExamLoading ||
                cubit is StudentExamResultsCubit &&
                    state is StudentExamResultsLoading) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            // استدعاء دالة الـ builder الأصلية في حالة النجاح
            return builder(state);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

// (بقية الويدجتس تبقى كما هي)
class _WelcomeHeader extends StatelessWidget {
  final String userName;
  const _WelcomeHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat(
      'EEEE, d MMMM yyyy',
      'ar',
    ).format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          todayDate,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          'أهلاً بك، ${userName.split(' ').first}',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _RecentAnnouncementsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "أحدث الإعلانات",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            TextButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnnouncementsListScreen(),
                    ),
                  ),
              child: const Text("عرض الكل"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementLoading) {
              return const LoadingList(itemCount: 3, cardHeight: 70);
            }
            if (state is AnnouncementLoaded) {
              if (state.announcements.isEmpty) {
                return const EmptyState(
                  message: "لا توجد إعلانات حالياً.",
                  icon: Icons.campaign_outlined,
                );
              }
              return Column(
                children:
                    state.announcements.take(3).map((announcement) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            announcement.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            announcement.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
              );
            }
            if (state is AnnouncementError) {
              return Text("خطأ: ${state.message}");
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
