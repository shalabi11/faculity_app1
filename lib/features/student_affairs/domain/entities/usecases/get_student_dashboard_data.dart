// lib/features/student_affairs/domain/entities/usecases/get_student_dashboard_data.dart

import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/usecases/usecase.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/student_dashboard_entity.dart';

class GetStudentDashboardData
    implements UseCase<StudentDashboardEntity, NoParams> {
  final StudentAffairsRepository repository;

  GetStudentDashboardData(this.repository);

  @override
  Future<Either<Failure, StudentDashboardEntity>> call(NoParams params) async {
    // 1. استدعاء الدالة الجديدة من الـ Repository التي تعيد قائمة بالطلاب
    final failureOrStudentsList = await repository.getStudents();

    // 2. استخدام fold لمعالجة النتيجة (إما فشل أو نجاح)
    return failureOrStudentsList.fold(
      (failure) {
        // في حال الفشل، قم بإرجاع الـ Failure كما هو
        return Left(failure);
      },
      (students) {
        // في حال النجاح، قم بتجميع الطلاب حسب السنة
        final Map<String, List<StudentModel>> studentsByYear = {
          'الأولى': [],
          'الثانية': [],
          'الثالثة': [],
          'الرابعة': [],
          'الخامسة': [],
        };

        for (var student in students) {
          if (studentsByYear.containsKey(student.year)) {
            // للتأكد من أن النوع متوافق
            studentsByYear[student.year]!.add(student as StudentModel);
          }
        }

        // إنشاء وإرجاع StudentDashboardEntity بعد تجميع البيانات
        return Right(StudentDashboardEntity(studentsByYear: studentsByYear));
      },
    );
  }
}
