// import 'package:faculity_app2/features/student/presentation/screens/mange_student_screen.dart';
// import 'package:flutter/material.dart';

// // --- استيراد الشاشات الإدارية التي سيتم الانتقال إليها ---

// class StudentAffairsHeadDashboard extends StatelessWidget {
//   const StudentAffairsHeadDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // استخدام GridView لعرض البطاقات بشكل منظم
//     return GridView.count(
//       crossAxisCount: 2, // عدد الأعمدة في الشبكة
//       padding: const EdgeInsets.all(16),
//       crossAxisSpacing: 16,
//       mainAxisSpacing: 16,
//       children: [
//         // --- هذه هي الطريقة الصحيحة والمبسطة لإنشاء البطاقات ---

//         // 1. بطاقة إدارة الطلاب (الوظيفة الأساسية لرئيس شؤون الطلاب)
//         DashboardCard(
//           title: 'إدارة الطلاب',
//           icon: Icons.groups_2_rounded,
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(builder: (_) => const ManageStudentsScreen()),
//             );
//           },
//         ),

//         // // 2. بطاقة متابعة الموظفين في قسمه
//         // DashboardCard(
//         //   title: 'متابعة الموظفين',
//         //   icon: Icons.person_search_rounded,
//         //   onTap: () {
//         //     // يفترض أن تفتح شاشة تعرض فقط موظفي قسم شؤون الطلاب
//         //     Navigator.of(context).push(
//         //       MaterialPageRoute(builder: (_) => const ManageStaffScreen()),
//         //     );
//         //   },
//         // ),

//         // 3. بطاقة إصدار تقارير طلابية
//         DashboardCard(
//           title: 'إصدار التقارير',
//           icon: Icons.assessment_rounded,
//           onTap: () {
//             // TODO: الانتقال إلى شاشة مخصصة لطباعة التقارير
//           },
//         ),

//         // 4. بطاقة الطلبات الطلابية المعلقة
//         DashboardCard(
//           title: 'الطلبات المعلقة',
//           icon: Icons.pending_actions_rounded,
//           onTap: () {
//             // TODO: الانتقال إلى شاشة لعرض ومتابعة طلبات الطلاب
//           },
//         ),
//       ],
//     );
//   }
// }

// // --- هذا هو التعريف الصحيح والمبسط لبطاقة لوحة التحكم ---
// // --- قم بنسخه ولصقه في كل ملف dashboard لضمان التوافق ---
// class DashboardCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final VoidCallback onTap;

//   // البطاقة الآن تستقبل كل خاصية بشكل مباشر
//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Card(
//         elevation: 4,
//         shadowColor: Colors.black.withOpacity(0.2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: Theme.of(context).primaryColor),
//             const SizedBox(height: 12),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Text(
//                 title,
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
