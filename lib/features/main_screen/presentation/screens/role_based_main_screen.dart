// import 'package:flutter/material.dart';
// import 'package:faculity_app2/features/auth/domain/entities/user_role.dart';

// // استدعاء لوحات التحكم المختلفة التي سنبنيها
// // import 'dashboards/dean_dashboard.dart';
// // import 'dashboards/student_affairs_head_dashboard.dart';

// class RoleBasedMainScreen extends StatelessWidget {
//   final UserRole role;
//   const RoleBasedMainScreen({super.key, required this.role});

//   Widget _getDashboardForRole() {
//     switch (role) {
//       // case UserRole.dean:
//       //   return const DeanDashboard();
//       // case UserRole.studentAffairsHead:
//       //   return const StudentAffairsHeadDashboard();
//       // ... أضف باقي الحالات هنا
//       default:
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'سيتم بناء الواجهة الخاصة بهذا الدور:\n${role.name}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 22),
//             ),
//           ),
//         );
//     }
//   }

//   String _getTitleForRole() {
//     switch (role) {
//       case UserRole.dean:
//         return 'لوحة تحكم العميد';
//       case UserRole.studentAffairsHead:
//         return 'لوحة تحكم رئيس شؤون الطلاب';
//       // ... أضف باقي العناوين هنا
//       default:
//         return 'لوحة التحكم الرئيسية';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(_getTitleForRole())),
//       body: _getDashboardForRole(),
//     );
//   }
// }
