// lib/features/student_affairs/presentation/cubit/student_affairs_dashboard_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_dashboard_state.dart';

class StudentAffairsDashboardCubit extends Cubit<StudentAffairsDashboardState> {
  final StudentAffairsRepository studentAffairsRepository;

  StudentAffairsDashboardCubit({required this.studentAffairsRepository})
    : super(StudentAffairsDashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(StudentAffairsDashboardLoading());
    try {
      final studentsResult = await studentAffairsRepository.getStudents();

      studentsResult.fold(
        (failure) => emit(StudentAffairsDashboardFailure(failure.toString())),
        (students) {
          // الآن نرسل فقط العدد الإجمالي للطلاب
          emit(StudentAffairsDashboardSuccess(totalStudents: students.length));
        },
      );
    } on Exception catch (e) {
      emit(StudentAffairsDashboardFailure(e.toString()));
    }
  }
}
