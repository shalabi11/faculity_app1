// import 'package:faculity_app2/features/admin/presentation/screens/manage_announcements_screen.dart';
// import 'package:faculity_app2/features/classrooms/presentation/screens/manage_classrooms_screen.dart';
// import 'package:faculity_app2/features/courses/presentation/screens/manage_course_screen.dart';
// import 'package:faculity_app2/features/exams/presentation/screens/manage_exams_screen.dart';
// import 'package:faculity_app2/features/schedule/presentation/screens/manage_schedule_screen.dart';
// import 'package:faculity_app2/features/student/presentation/screens/mange_student_screen.dart';
// import 'package:faculity_app2/features/teachers/presentation/screens/manage_teachers_screen.dart';
// import 'package:flutter/material.dart';

// // --- استيراد جميع الشاشات الإدارية التي سيتم الانتقال إليها ---

// // --- هذا الكلاس الصغير يساعد في تنظيم البيانات ---
// class DashboardItem {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;

//   DashboardItem({required this.title, required this.icon, required this.onTap});
// }

// class DeanDashboard extends StatelessWidget {
//   const DeanDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // --- قمنا بتعريف قائمة بالبطاقات هنا لتنظيم الكود ---
//     final List<DashboardItem> dashboardItems = [
//       DashboardItem(
//         title: 'إدارة الإعلانات',
//         icon: Icons.campaign_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => const ManageAnnouncementsScreen(),
//               ),
//             ),
//       ),
//       DashboardItem(
//         title: 'إدارة الطلاب',
//         icon: Icons.groups_2_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageStudentsScreen()),
//             ),
//       ),
//       DashboardItem(
//         title: 'إدارة المدرسين',
//         icon: Icons.person_search_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageTeachersScreen()),
//             ),
//       ),
//       // DashboardItem(
//       //   title: 'إدارة الموظفين',
//       //   icon: Icons.badge_rounded,
//       //   onTap:
//       //       () => Navigator.of(context).push(
//       //         MaterialPageRoute(builder: (_) => const ManageStaffScreen()),
//       //       ),
//       // ),
//       DashboardItem(
//         title: 'إدارة المواد',
//         icon: Icons.library_books_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageCoursesScreen()),
//             ),
//       ),
//       DashboardItem(
//         title: 'إدارة القاعات',
//         icon: Icons.meeting_room_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageClassroomsScreen()),
//             ),
//       ),
//       DashboardItem(
//         title: 'إدارة الامتحانات',
//         icon: Icons.edit_calendar_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageExamsScreen()),
//             ),
//       ),
//       DashboardItem(
//         title: 'إدارة الجداول',
//         icon: Icons.calendar_month_rounded,
//         onTap:
//             () => Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageSchedulesScreen()),
//             ),
//       ),
//     ];

//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       padding: const EdgeInsets.all(16),
//       itemCount: dashboardItems.length,
//       itemBuilder: (context, index) {
//         // --- التصحيح هنا: نمرر الغرض الكامل للبطاقة ---
//         return DashboardCard(item: dashboardItems[index]);
//       },
//     );
//   }
// }

// // --- ويدجت البطاقة الآن أصبح أبسط وأنظف ---
// class DashboardCard extends StatelessWidget {
//   const DashboardCard({super.key, required this.item});

//   final DashboardItem item;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: item.onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Card(
//         elevation: 4,
//         shadowColor: Colors.black.withOpacity(0.2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(item.icon, size: 40, color: Theme.of(context).primaryColor),
//             const SizedBox(height: 12),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4.0),
//               child: Text(
//                 item.title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
