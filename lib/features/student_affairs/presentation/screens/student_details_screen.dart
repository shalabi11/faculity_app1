import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  final StudentModel student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.fullName),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                // يمكنك استخدام صورة الطالب إذا كانت متوفرة
                // backgroundImage: NetworkImage(student.profileImageUrl),
                backgroundColor: Colors.teal.shade100,
                child: Text(
                  student.fullName[0],
                  style: TextStyle(fontSize: 40, color: Colors.teal.shade800),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('الاسم الكامل', student.fullName),
            _buildDetailRow('الرقم الجامعي', student.universityId),
            _buildDetailRow('اسم الأم', student.motherName),
            _buildDetailRow(
              'تاريخ الميلاد',
              student.birthDate.toString().split(' ')[0],
            ),
            _buildDetailRow('مكان الولادة', student.birthPlace),
            _buildDetailRow('القسم', student.department),
            _buildDetailRow('السنة الدراسية', student.year),
            // أضف أي حقول أخرى بنفس الطريقة
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
