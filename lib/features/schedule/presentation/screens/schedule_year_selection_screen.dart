import 'package:faculity_app2/features/schedule/presentation/screens/schedule_management_screen.dart';
import 'package:flutter/material.dart';
// سنقوم بإنشاء هذه الشاشة في الخطوة التالية
// import 'package:faculity_app2/features/schedule/presentation/screens/schedule_management_screen.dart';

class ScheduleYearSelectionScreen extends StatelessWidget {
  const ScheduleYearSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة السنوات الدراسية
    final years = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر السنة الدراسية'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              title: Text(
                'السنة $year',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // سيتم تفعيل هذا الكود للانتقال إلى شاشة إدارة الجدول

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScheduleManagementScreen(year: year),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
