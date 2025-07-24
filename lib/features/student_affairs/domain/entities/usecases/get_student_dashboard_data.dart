import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/usecases/usecase.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/student_dashboard_entity.dart';

class GetStudentDashboardData
    implements UseCase<StudentDashboardEntity, NoParams> {
  final StudentAffairsRepository repository;

  GetStudentDashboardData(this.repository);

  @override
  Future<Either<Failure, StudentDashboardEntity>> call(NoParams params) async {
    return await repository.getStudentDashboardData();
  }
}
