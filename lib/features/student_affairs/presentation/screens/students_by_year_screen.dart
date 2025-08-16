// lib/features/student_affairs/presentation/screens/students_by_year_screen.dart

import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'student_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ✨ 1. تحويل الويدجت إلى StatefulWidget لإدارة حالة البحث
class StudentsByYearScreen extends StatefulWidget {
  final String year;
  final List<StudentModel> students;

  const StudentsByYearScreen({
    super.key,
    required this.year,
    required this.students,
  });

  @override
  State<StudentsByYearScreen> createState() => _StudentsByYearScreenState();
}

class _StudentsByYearScreenState extends State<StudentsByYearScreen> {
  late List<StudentModel> _filteredStudents;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.students;
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents =
          widget.students.where((student) {
            return student.fullName.toLowerCase().contains(query) ||
                student.universityId.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلاب السنة ${widget.year}'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: Column(
        children: [
          // ✨ 2. إضافة حقل البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو الرقم الجامعي...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(
            child:
                _filteredStudents.isEmpty
                    ? const Center(child: Text('لا يوجد طلاب يطابقون بحثك.'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = _filteredStudents[index];
                        // ✨ 3. استخدام بطاقة الطالب الجديدة
                        return _StudentCard(student: student)
                            .animate()
                            .fade(delay: (100 * index).ms)
                            .slideY(begin: 0.2);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

// ✨ --- 4. ويدجت جديد لبطاقة الطالب بتصميم محسن --- ✨
class _StudentCard extends StatelessWidget {
  final StudentModel student;
  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDetailsScreen(student: student),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.teal.shade100,
                child: Text(
                  student.fullName.isNotEmpty ? student.fullName[0] : 'S',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الرقم الجامعي: ${student.universityId}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
