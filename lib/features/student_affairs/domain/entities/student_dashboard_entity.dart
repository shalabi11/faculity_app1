// في ملف: lib/features/student_affairs/domain/entities/student_dashboard_entity.dart

import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart'; // <-- أضف هذا السطر

class StudentDashboardEntity extends Equatable {
  // غير السطر التالي من int إلى List<StudentModel>
  final Map<String, List<StudentModel>> studentsByYear;

  const StudentDashboardEntity({required this.studentsByYear});

  @override
  List<Object?> get props => [studentsByYear];
}
