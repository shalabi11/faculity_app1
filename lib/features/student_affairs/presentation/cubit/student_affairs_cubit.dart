import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/usecases/usecase.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/student_dashboard_entity.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/get_student_dashboard_data.dart';

part 'student_affairs_state.dart';

class StudentAffairsCubit extends Cubit<StudentAffairsState> {
  final GetStudentDashboardData getStudentDashboardData;

  StudentAffairsCubit({required this.getStudentDashboardData})
    : super(StudentAffairsInitial());

  // --- هذه هي الدالة التي تستدعيها من الشاشة ---
  // لاحظ أنها لا تأخذ أي بارامترات
  Future<void> fetchDashboardData() async {
    emit(StudentAffairsLoading());

    // الـ Cubit داخلياً هو الذي يقوم باستدعاء الـ UseCase وتمرير NoParams له
    final failureOrData = await getStudentDashboardData(NoParams());

    failureOrData.fold((failure) {
      String errorMessage = 'فشل في جلب البيانات';
      if (failure is ServerFailure) {
        errorMessage = failure.message; // <-- هذا هو السطر المهم
      }
      emit(StudentAffairsError(message: errorMessage));
    }, (data) => emit(StudentAffairsLoaded(dashboardData: data)));
  }
}
