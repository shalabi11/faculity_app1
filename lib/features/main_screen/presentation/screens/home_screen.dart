// lib/features/main_screen/presentation/screens/home_screen.dart

import 'package:collection/collection.dart';
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:faculity_app2/features/announcements/presentation/screens/announcements_list_screen.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';
import 'package:faculity_app2/features/main_screen/presentation/widget/home_screen_widgets.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    _WelcomeHeader(userName: widget.user.name),
                    const SizedBox(height: 24),

                    // ✨ --- 1. استخدام بطاقات مخصصة لكل قسم --- ✨

                    // بطاقة نظرة على أسبوعك
                    _DashboardCard(
                      title: "نظرة على أسبوعك",
                      icon: Icons.bar_chart_outlined,
                      child: BlocBuilder<ScheduleCubit, ScheduleState>(
                        builder: (context, state) {
                          if (state is ScheduleLoading) {
                            return const _LoadingPlaceholder();
                          }
                          if (state is ScheduleFailure) {
                            return Text(state.message);
                          }
                          if (state is ScheduleSuccess) {
                            return WeeklyScheduleChart(
                              schedule: state.schedule,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // بطاقة الامتحان القادم
                    _DashboardCard(
                      title: "الامتحان القادم",
                      icon: Icons.edit_calendar_outlined,
                      child: BlocBuilder<ExamCubit, ExamState>(
                        builder: (context, state) {
                          if (state is ExamLoading) {
                            return const _LoadingPlaceholder();
                          }
                          if (state is ExamError) {
                            return Text(state.message);
                          }
                          if (state is ExamLoaded) {
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
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
                            upcomingExams.sort(
                              (a, b) => DateTime.parse(
                                a.examDate,
                              ).compareTo(DateTime.parse(b.examDate)),
                            );
                            final nextExam = upcomingExams.firstOrNull;
                            if (nextExam == null) {
                              return const Center(
                                child: Text("لا يوجد امتحانات قادمة."),
                              );
                            }
                            return ExamCountdownWidget(exam: nextExam);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // بطاقة أداء العلامات
                    _DashboardCard(
                      title: "أداء العلامات",
                      icon: Icons.show_chart_outlined,
                      child: BlocBuilder<
                        StudentExamResultsCubit,
                        StudentExamResultsState
                      >(
                        builder: (context, state) {
                          if (state is StudentExamResultsLoading) {
                            return const _LoadingPlaceholder();
                          }
                          if (state is StudentExamResultsFailure) {
                            return Text(state.message);
                          }
                          if (state is StudentExamResultsSuccess) {
                            if (state.results.isEmpty) {
                              return const Center(
                                child: Text("لم تصدر أي نتائج بعد."),
                              );
                            }
                            return GradesPerformanceChart(
                              results: state.results,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    // قسم الإعلانات (يمكن تركه كما هو أو وضعه في بطاقة أيضاً)
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
}

// ✨ --- 2. ويدجت جديد وموحد لشكل بطاقات لوحة التحكم --- ✨
class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

// ويدجت بسيط لعرضه أثناء التحميل داخل البطاقة
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

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
