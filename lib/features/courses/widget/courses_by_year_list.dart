// lib/features/courses/presentation/widgets/courses_by_year_list.dart

import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:flutter/material.dart';

// ويدجت مشترك لعرض قائمة مواد مجمعة حسب السنة
class CoursesByYearList extends StatelessWidget {
  final List<CourseEntity> courses;
  // دالة Callback ليتم تنفيذها عند الضغط على أي مادة
  final Function(CourseEntity) onCourseTap;
  // ويدجت اختياري ليتم عرضه بجانب كل مادة (مثل أزرار التعديل والحذف)
  final Widget? Function(CourseEntity)? trailingBuilder;

  const CoursesByYearList({
    super.key,
    required this.courses,
    required this.onCourseTap,
    this.trailingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // 1. تجميع المواد حسب السنة
    final Map<String, List<CourseEntity>> coursesByYear = {};
    for (var course in courses) {
      (coursesByYear[course.year] ??= []).add(course);
    }

    // 2. ترتيب السنوات (اختياري ولكنه يحسن الواجهة)
    final sortedYears = coursesByYear.keys.toList()..sort();

    if (sortedYears.isEmpty) {
      return const Center(child: Text('لا توجد مواد لعرضها.'));
    }

    // 3. بناء الواجهة باستخدام ListView
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: sortedYears.length,
      itemBuilder: (context, index) {
        final year = sortedYears[index];
        final yearCourses = coursesByYear[year]!;

        // استخدام ExpansionTile لعرض كل سنة كقسم قابل للفتح والإغلاق
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2,
          child: ExpansionTile(
            initiallyExpanded: true, // جعل الأقسام مفتوحة بشكل افتراضي
            title: Text(
              'السنة $year',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            children:
                yearCourses.map((course) {
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text('القسم: ${course.department}'),
                    onTap: () => onCourseTap(course),
                    trailing:
                        trailingBuilder != null
                            ? trailingBuilder!(course)
                            : null,
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
