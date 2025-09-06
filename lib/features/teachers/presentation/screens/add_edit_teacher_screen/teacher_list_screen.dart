// lib/features/teachers/presentation/screens/add_edit_teacher_screen/teacher_list_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/add_edit_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TeacherCubit>()..fetchTeachers(),
      child: const _TeacherListView(),
    );
  }
}

// ✨ 1. تحويل الويدجت إلى StatefulWidget
class _TeacherListView extends StatefulWidget {
  const _TeacherListView();

  @override
  State<_TeacherListView> createState() => _TeacherListViewState();
}

class _TeacherListViewState extends State<_TeacherListView> {
  // ✨ 2. متغيرات لإدارة حالة البحث
  final _searchController = TextEditingController();
  List<TeacherEntity> _allTeachers = [];
  List<TeacherEntity> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTeachers);
    _searchController.dispose();
    super.dispose();
  }

  // ✨ 3. دالة لفلترة قائمة الدكاترة
  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers =
          _allTeachers.where((teacher) {
            return teacher.fullName.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _refreshData() {
    context.read<TeacherCubit>().fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الدكاترة')),
      body: Column(
        children: [
          // ✨ 4. إضافة حقل البحث في الواجهة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن دكتور...',
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
            child: BlocConsumer<TeacherCubit, TeacherState>(
              listener: (context, state) {
                if (state is TeacherSuccess) {
                  setState(() {
                    _allTeachers = state.teachers;
                    _filteredTeachers = state.teachers;
                    // إعادة الفلترة بعد تحديث البيانات
                    _filterTeachers();
                  });
                }
              },
              builder: (context, state) {
                if (state is TeacherLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TeacherFailure) {
                  return Center(child: Text('خطأ: ${state.message}'));
                }
                if (state is TeacherSuccess) {
                  if (_filteredTeachers.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد دكاترة يطابقون بحثك.'),
                    );
                  }
                  // ✨ 5. استخدام القائمة المفلترة للعرض
                  return ListView.builder(
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (context, index) {
                      final teacher = _filteredTeachers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(teacher.fullName[0]),
                          ),
                          title: Text(teacher.fullName),
                          subtitle: Text(teacher.department),
                          onTap: () {
                            // يمكنك هنا الانتقال لصفحة تفاصيل الدكتور
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTeacherScreen()),
          ).then((_) => _refreshData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
