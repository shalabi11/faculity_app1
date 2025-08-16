// lib/features/exams/presentation/screens/exam_result_screen.dart

import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';
import 'package:faculity_app2/features/exams/presentation/screens/grade_entry_screen.dart';

class ExamSelectionForResultsScreen extends StatefulWidget {
  const ExamSelectionForResultsScreen({super.key});

  @override
  State<ExamSelectionForResultsScreen> createState() =>
      _ExamSelectionForResultsScreenState();
}

class _ExamSelectionForResultsScreenState
    extends State<ExamSelectionForResultsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ExamEntity> _allExams = [];
  List<ExamEntity> _filteredExams = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterExams);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterExams);
    _searchController.dispose();
    super.dispose();
  }

  void _filterExams() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExams =
          _allExams
              .where((exam) => exam.courseName.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ExamCubit>()..fetchExams(),
      child: Scaffold(
        appBar: AppBar(title: const Text('إدارة العلامات'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث عن مقرر...',
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
              child: BlocConsumer<ExamCubit, ExamState>(
                listener: (context, state) {
                  if (state is ExamLoaded) {
                    setState(() {
                      _allExams = state.exams;
                      _filteredExams = state.exams;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ExamLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ExamLoaded) {
                    if (_filteredExams.isEmpty) {
                      return const Center(
                        child: Text('لا توجد امتحانات تطابق بحثك.'),
                      );
                    }
                    // ✨ 1. استدعاء الويدجت الجديد
                    return _buildExamsByYearList(_filteredExams);
                  }
                  if (state is ExamError) {
                    return ErrorState(
                      message: state.message,
                      onRetry: () => context.read<ExamCubit>().fetchExams(),
                    );
                  }
                  return const Center(child: Text('جاري التحميل...'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✨ 2. ويدجت جديد لعرض الامتحانات مجمعة حسب السنة
  Widget _buildExamsByYearList(List<ExamEntity> exams) {
    final Map<String, List<ExamEntity>> examsByYear = {};
    for (var exam in exams) {
      final year = exam.targetYear ?? 'غير محدد';
      (examsByYear[year] ??= []).add(exam);
    }
    final sortedYears = examsByYear.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: sortedYears.length,
      itemBuilder: (context, index) {
        final year = sortedYears[index];
        final yearExams = examsByYear[year]!;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'السنة $year',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            children:
                yearExams.map((exam) {
                  return ListTile(
                    title: Text(exam.courseName),
                    subtitle: Text('التاريخ: ${exam.examDate}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GradeEntryScreen(exam: exam),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
