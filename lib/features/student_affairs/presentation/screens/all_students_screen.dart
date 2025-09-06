// lib/features/student_affairs/presentation/screens/all_students_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/all_students_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllStudentsScreen extends StatelessWidget {
  const AllStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AllStudentsCubit>()..fetchAllStudents(),
      child: const _AllStudentsView(),
    );
  }
}

class _AllStudentsView extends StatefulWidget {
  const _AllStudentsView();

  @override
  State<_AllStudentsView> createState() => _AllStudentsViewState();
}

class _AllStudentsViewState extends State<_AllStudentsView> {
  final _searchController = TextEditingController();
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
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
          _allStudents.where((student) {
            return student.fullName.toLowerCase().contains(query) ||
                student.universityId.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عرض كل الطلاب')),
      body: Column(
        children: [
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
            child: BlocConsumer<AllStudentsCubit, AllStudentsState>(
              listener: (context, state) {
                if (state is AllStudentsSuccess) {
                  setState(() {
                    _allStudents = state.students;
                    _filteredStudents = state.students;
                  });
                }
              },
              builder: (context, state) {
                if (state is AllStudentsLoading) {
                  return const Center(child: LoadingList());
                }
                if (state is AllStudentsFailure) {
                  return Center(child: Text('خطأ: ${state.message}'));
                }
                if (state is AllStudentsSuccess) {
                  if (_filteredStudents.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد طلاب يطابقون بحثك.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return _StudentCard(student: student);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final Student student;
  const _StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(student.fullName.isNotEmpty ? student.fullName[0] : 'S'),
        ),
        title: Text(student.fullName),
        subtitle: Text('الرقم الجامعي: ${student.universityId} '),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDetailsScreen(student: student),
            ),
          );
        },
      ),
    );
  }
}
