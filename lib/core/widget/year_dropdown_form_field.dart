// lib/core/widget/year_dropdown_form_field.dart

import 'package:flutter/material.dart';

class YearDropdownFormField extends StatelessWidget {
  final String? selectedYear;
  final ValueChanged<String?> onChanged;

  const YearDropdownFormField({
    super.key,
    required this.selectedYear,
    required this.onChanged,
  });

  // قائمة ثابتة بالسنوات الدراسية المتاحة
  static const List<String> _academicYears = [
    'الأولى',
    'الثانية',
    'الثالثة',
    'الرابعة',
    'الخامسة',
  ];

  // ✨ 1. إضافة قيمة خاصة للطلاب غير المسجلين
  static const String unassignedYearValue = 'غير محدد';

  @override
  Widget build(BuildContext context) {
    // ✨ 2. إنشاء قائمة العناصر الديناميكية
    final List<DropdownMenuItem<String>> items = [];

    // إضافة خيار الطلاب غير المسجلين أولاً
    items.add(
      const DropdownMenuItem(
        value: unassignedYearValue,
        child: Text(
          'طلاب غير مسجلين بسنة',
          style: TextStyle(color: Colors.orange),
        ),
      ),
    );

    // إضافة بقية السنوات
    items.addAll(
      _academicYears.map((year) {
        return DropdownMenuItem(value: year, child: Text('السنة $year'));
      }),
    );

    return DropdownButtonFormField<String>(
      value: selectedYear,
      decoration: const InputDecoration(
        labelText: 'السنة الدراسية',
        border: OutlineInputBorder(),
        filled: true,
      ),
      hint: const Text('اختر لعرض الطلاب...'),
      isExpanded: true,
      items: items, // استخدام القائمة الجديدة
      onChanged: onChanged,
      validator: (value) => value == null ? 'يرجى اختيار حقل' : null,
    );
  }
}
