import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';

abstract class StaffRepository {
  Future<Either<Failure, List<StaffEntity>>> getAllStaff();
  Future<Either<Failure, Unit>> addStaff(Map<String, dynamic> staffData);
  Future<Either<Failure, Unit>> deleteStaff(int staffId);
  Future<Either<Failure, Unit>> updateStaff(
    int staffId,
    Map<String, dynamic> staffData,
  );
}
