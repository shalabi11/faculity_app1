// lib/features/student_affairs/presentation/cubit/all_students_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

part 'all_students_state.dart';

class AllStudentsCubit extends Cubit<AllStudentsState> {
  final StudentAffairsRepository studentAffairsRepository;

  AllStudentsCubit({required this.studentAffairsRepository})
    : super(AllStudentsInitial());

  Future<void> fetchAllStudents() async {
    emit(AllStudentsLoading());
    final result = await studentAffairsRepository.getStudents();
    result.fold(
      (failure) => emit(AllStudentsFailure(failure.toString())),
      (students) => emit(AllStudentsSuccess(students)),
    );
  }
}
