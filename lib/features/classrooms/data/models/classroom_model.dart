// lib/features/classrooms/data/models/classroom_model.dart

import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';

class ClassroomModel extends Classroom {
  const ClassroomModel({
    required super.id,
    required super.name,
    required super.type,
    super.createdAt,
    super.updatedAt,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'اسم غير متوفر',
      type: json['type'] ?? 'نوع غير محدد',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }
}
