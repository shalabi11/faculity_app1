// // --- ويدجت البطاقة الآن أصبح أبسط وأنظف ---
// import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
// import 'package:flutter/material.dart';

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
