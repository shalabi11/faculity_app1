import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'student_details_screen.dart';

class StudentsByYearScreen extends StatelessWidget {
  final String year;
  final List<StudentModel> students;

  const StudentsByYearScreen({
    super.key,
    required this.year,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلاب السنة $year'),
        backgroundColor: Colors.teal.shade700,
      ),
      body:
          students.isEmpty
              ? const Center(child: Text('لا يوجد طلاب في هذه السنة.'))
              : ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          student.fullName[0],
                          style: TextStyle(color: Colors.teal.shade800),
                        ),
                      ),
                      title: Text(
                        student.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('الرقم الجامعي: ${student.universityId}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => StudentDetailsScreen(student: student),
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
