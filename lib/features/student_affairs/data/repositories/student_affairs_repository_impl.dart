import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/platform/network_info.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student_affairs/data/datasource/student_affairs_remote_data_source.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/student_dashboard_entity.dart';

class StudentAffairsRepositoryImpl implements StudentAffairsRepository {
  final StudentAffairsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StudentAffairsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, StudentDashboardEntity>>
  getStudentDashboardData() async {
    if (await networkInfo.isConnected) {
      try {
        final studentCountsMap =
            await remoteDataSource.getStudentDashboardData();
        final dashboardEntity = StudentDashboardEntity(
          studentsByYear: studentCountsMap,
        );
        return Right(dashboardEntity);
      } on ServerException catch (e) {
        // -- التعديل هنا --
        // نقوم بتمرير الرسالة التفصيلية إلى طبقة الـ Failure
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addStudent(
    StudentModel student,
    File? image,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addStudent(student, image);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure(message: ''));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
