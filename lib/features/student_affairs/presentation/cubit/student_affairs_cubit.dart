// lib/features/student_affairs/presentation/cubit/student_affairs_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

part 'student_affairs_state.dart';

class StudentAffairsCubit extends Cubit<StudentAffairsState> {
  final StudentAffairsRepository studentAffairsRepository;

  StudentAffairsCubit({required this.studentAffairsRepository})
    : super(StudentAffairsInitial());

  Future<void> fetchStudents() async {
    emit(StudentAffairsLoading());
    final failureOrStudents = await studentAffairsRepository.getStudents();
    failureOrStudents.fold((failure) {
      String message = 'فشل في جلب البيانات';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(StudentAffairsError(message: message));
    }, (students) => emit(StudentAffairsLoaded(students: students)));
  }
}
