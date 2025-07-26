// import 'package:faculity_app2/core/widget/app_state_widget.dart';
// import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
// import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
// import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';
// import 'package:faculity_app2/features/exams/presentation/screens/exam_result_screen.dart';
// import 'package:faculity_app2/features/main_screen/presentation/screens/exams_screen.dart';
// import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:faculity_app2/core/services/service_locator.dart';
// import 'package:faculity_app2/core/theme/app_color.dart';
// import 'package:faculity_app2/features/auth/domain/entities/user.dart';
// // Cubits
// import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
// import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
// import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
// import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
// // Entities
// import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
// import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
// import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
// import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
// // Packages
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// // Screens for navigation
// import 'package:faculity_app2/features/announcements/presentation/screens/announcements_list_screen.dart';
// import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';

// class HomeScreen extends StatefulWidget {
//   final User user;
//   const HomeScreen({super.key, required this.user});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('ar', null);
//   }

//   void _refreshData() {
//     // دالة لتحديث كل بيانات الشاشة الرئيسية
//     context.read<ScheduleCubit>().fetchTheorySchedule(
//       year: widget.user.year ?? '',
//     );
//     context.read<StudentExamResultsCubit>().fetchStudentResults(
//       studentId: widget.user.id,
//     );
//     context.read<AnnouncementCubit>().fetchAnnouncements();
//     context.read<ExamCubit>().fetchExams();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create:
//               (context) =>
//                   sl<ScheduleCubit>()
//                     ..fetchTheorySchedule(year: widget.user.year ?? ''),
//         ),
//         BlocProvider(
//           create:
//               (context) =>
//                   sl<StudentExamResultsCubit>()
//                     ..fetchStudentResults(studentId: widget.user.id),
//         ),
//         BlocProvider(
//           create: (context) => sl<AnnouncementCubit>()..fetchAnnouncements(),
//         ),
//         BlocProvider(create: (context) => sl<ExamCubit>()..fetchExams()),
//       ],
//       child: Scaffold(
//         body: RefreshIndicator(
//           onRefresh: () async => _refreshData(),
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 24.0,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                       _WelcomeHeader(userName: widget.user.name),
//                       const SizedBox(height: 24),
//                       _TodayScheduleSection(user: widget.user),
//                       const SizedBox(height: 24),
//                       _UpcomingExamSection(),
//                       const SizedBox(height: 24),
//                       _LatestResultSection(),
//                       const SizedBox(height: 24),
//                       _RecentAnnouncementsSection(),
//                     ]
//                     .animate(interval: 80.ms)
//                     .fade(duration: 400.ms)
//                     .slideY(begin: 0.2),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // --- ويدجتس الواجهة المقسمة ---

// class _WelcomeHeader extends StatelessWidget {
//   final String userName;
//   const _WelcomeHeader({required this.userName});

//   @override
//   Widget build(BuildContext context) {
//     final String todayDate = DateFormat(
//       'EEEE, d MMMM yyyy',
//       'ar',
//     ).format(DateTime.now());
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           todayDate,
//           style: Theme.of(
//             context,
//           ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           'أهلاً بك، ${userName.split(' ').first}',
//           style: Theme.of(
//             context,
//           ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }

// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback? onSeeAll;

//   const _SectionHeader({required this.title, this.onSeeAll});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(title, style: Theme.of(context).textTheme.headlineSmall),
//         if (onSeeAll != null)
//           TextButton(onPressed: onSeeAll, child: const Text("عرض الكل")),
//       ],
//     );
//   }
// }

// class _TodayScheduleSection extends StatelessWidget {
//   final User user;
//   const _TodayScheduleSection({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     if (user.year == null) {
//       return const SizedBox.shrink(); // لا تعرض القسم إذا لم تكن السنة محددة
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           title: "محاضرات اليوم",
//           onSeeAll: () {
//             /* TODO: Implement navigation */
//           },
//         ),
//         const SizedBox(height: 8),
//         BlocBuilder<ScheduleCubit, ScheduleState>(
//           builder: (context, state) {
//             if (state is ScheduleLoading) {
//               return const LoadingList(itemCount: 2, cardHeight: 65);
//             }
//             if (state is ScheduleSuccess) {
//               final todayDayName = DateFormat(
//                 'EEEE',
//                 'ar',
//               ).format(DateTime.now());
//               final todayLectures =
//                   state.schedule
//                       .where((lecture) => lecture.day == todayDayName)
//                       .toList();

//               if (todayLectures.isEmpty) {
//                 return const EmptyState(
//                   message: "لا توجد محاضرات لديك اليوم!",
//                   icon: Icons.celebration_rounded,
//                 );
//               }
//               return _buildEntries(todayLectures);
//             }
//             if (state is ScheduleFailure) {
//               return Text("خطأ: ${state.message}");
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildEntries(List<ScheduleEntity> entries) {
//     return Column(
//       children:
//           entries
//               .map(
//                 (entry) => Card(
//                   elevation: 0,
//                   margin: const EdgeInsets.only(bottom: 8),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.grey.shade200),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.access_time_filled_rounded,
//                       color: AppColors.primary,
//                     ),
//                     title: Text(
//                       entry.courseName,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(entry.teacherName),
//                     trailing: Text("${entry.startTime} - ${entry.endTime}"),
//                   ),
//                 ),
//               )
//               .toList(),
//     );
//   }
// }

// // --- القسم الجديد: الامتحان القادم (مع التصحيح المنطقي) ---
// class _UpcomingExamSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           title: "الامتحان القادم",
//           onSeeAll: () {},
//           // () => Navigator.of(context).push(
//           //   MaterialPageRoute(
//           //     builder: (_) => const ExamsScreen(user: null,),
//           //   ),
//           // ),
//         ),
//         const SizedBox(height: 8),
//         BlocBuilder<ExamCubit, ExamState>(
//           builder: (context, state) {
//             if (state is ExamLoading) {
//               return const LoadingList(itemCount: 1, cardHeight: 80);
//             }
//             if (state is ExamLoaded) {
//               // --- التصحيح المنطقي هنا ---
//               final now = DateTime.now();
//               final today = DateTime(
//                 now.year,
//                 now.month,
//                 now.day,
//               ); // اليوم الساعة 00:00

//               final upcomingExams =
//                   state.exams
//                       .where(
//                         (exam) => !exam.examDate.isBefore(today),
//                       ) // جلب امتحانات اليوم والمستقبل
//                       .toList();

//               if (upcomingExams.isEmpty) {
//                 return const EmptyState(
//                   message: "لم يتم تحديد امتحانات قادمة بعد.",
//                   icon: Icons.edit_calendar_outlined,
//                 );
//               }
//               // فرز الامتحانات لعرض الأقرب أولاً
//               upcomingExams.sort((a, b) => a.examDate.compareTo(b.examDate));
//               return _ExamCard(exam: upcomingExams.first);
//             }
//             if (state is ExamError) {
//               return Text("خطأ: ${state.message}");
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
// }

// class _ExamCard extends StatelessWidget {
//   final ExamEntity exam;
//   const _ExamCard({required this.exam});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       color: AppColors.primary.withOpacity(0.05),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 12,
//         ),
//         leading: const CircleAvatar(child: Icon(Icons.edit_calendar_outlined)),
//         title: Text(
//           exam.courseName,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(
//           'بتاريخ: ${DateFormat('EEEE, d MMMM', 'ar').format(exam.examDate)}',
//         ),
//         trailing: Text(
//           exam.startTime,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class _LatestResultSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           title: "آخر نتيجة",
//           onSeeAll: () {},
//           // () => Navigator.of(context).push(
//           //   MaterialPageRoute(
//           //     builder: (_) => const ExamResultScreen(user:.user,),
//           //   ),
//           // ),
//         ),
//         const SizedBox(height: 8),
//         BlocBuilder<StudentExamResultsCubit, StudentExamResultsState>(
//           builder: (context, state) {
//             if (state is StudentExamResultsLoading) {
//               return const LoadingList(itemCount: 1, cardHeight: 80);
//             }
//             if (state is StudentExamResultsSuccess) {
//               if (state.results.isEmpty) {
//                 return const EmptyState(
//                   message: "لم تصدر أي نتائج بعد.",
//                   icon: Icons.school_outlined,
//                 );
//               }
//               return _ResultCard(result: state.results.first);
//             }
//             if (state is StudentExamResultsFailure) {
//               return Text("خطأ: ${state.message}");
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }
// }

// class _ResultCard extends StatelessWidget {
//   final ExamResult result;
//   const _ResultCard({required this.result});

//   @override
//   Widget build(BuildContext context) {
//     final bool isSuccess = result.score >= 50;
//     final Color color = isSuccess ? AppColors.success : AppColors.error;
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: color.withOpacity(0.5)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Icon(
//           isSuccess ? Icons.check_circle_outline : Icons.highlight_off,
//           color: color,
//           size: 32,
//         ),
//         title: Text(
//           result.courseName,
//           style: Theme.of(
//             context,
//           ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//         ),
//         trailing: Text(
//           result.score.toString(),
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RecentAnnouncementsSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _SectionHeader(
//           title: "أحدث الإعلانات",
//           onSeeAll:
//               () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => const AnnouncementsListScreen(),
//                 ),
//               ),
//         ),
//         const SizedBox(height: 8),
//         BlocBuilder<AnnouncementCubit, AnnouncementState>(
//           builder: (context, state) {
//             if (state is AnnouncementLoading) {
//               return const LoadingList(itemCount: 3, cardHeight: 70);
//             }
//             if (state is AnnouncementLoaded) {
//               if (state.announcements.isEmpty) {
//                 return const EmptyState(
//                   message: "لا توجد إعلانات حالياً.",
//                   icon: Icons.campaign_outlined,
//                 );
//               }
//               return _buildAnnouncements(state.announcements.take(3).toList());
//             }
//             if (state is AnnouncementError) {
//               return Text("خطأ: ${state.message}");
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildAnnouncements(List<Announcement> announcements) {
//     return Column(
//       children:
//           announcements
//               .map(
//                 (announcement) => Card(
//                   elevation: 0,
//                   margin: const EdgeInsets.only(bottom: 8),
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(color: Colors.grey.shade200),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: AppColors.secondary.withOpacity(0.1),
//                       child: Icon(
//                         Icons.campaign_rounded,
//                         color: AppColors.secondary,
//                       ),
//                     ),
//                     title: Text(
//                       announcement.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       announcement.content,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Text(
//                       DateFormat('d MMM', 'ar').format(announcement.createdAt),
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//     );
//   }
// }
