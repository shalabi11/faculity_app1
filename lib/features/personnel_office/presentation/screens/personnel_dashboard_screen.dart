import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/teacher_list_screen.dart';
import 'package:flutter/material.dart';
// لاحقاً، سنقوم بإنشاء هذه الشاشات
// import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
// import 'package:faculity_app2/features/teacher/presentation/screens/teacher_list_screen.dart';

class PersonnelDashboardScreen extends StatelessWidget {
  const PersonnelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتب الذاتية'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // عرض عمودين
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context: context,
              title: 'قسم الدكاترة',
              icon: Icons.school_outlined,
              color: Colors.orange.shade700,
              onTap: () {
                // سيتم تفعيل هذا الكود بعد إنشاء شاشة الدكاترة
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeacherListScreen()),
                );
                print('Navigate to Teachers Screen');
              },
            ),
            _buildDashboardCard(
              context: context,
              title: 'قسم الموظفين',
              icon: Icons.people_alt_outlined,
              color: Colors.blue.shade700,
              onTap: () {
                // سيتم تفعيل هذا الكود بعد إنشاء شاشة الموظفين
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StaffListScreen()),
                );
                print('Navigate to Staff Screen');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت خاصة لبناء بطاقات لوحة التحكم بشكل منظم
  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
