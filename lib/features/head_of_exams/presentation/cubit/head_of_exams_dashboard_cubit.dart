import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/head_of_exams/domain/repository/head_of_exams_repository.dart';

part 'head_of_exams_dashboard_state.dart';

class HeadOfExamsDashboardCubit extends Cubit<HeadOfExamsDashboardState> {
  final HeadOfExamsRepository headOfExamsRepository;
  final ExamRepository examRepository;

  HeadOfExamsDashboardCubit({
    required this.headOfExamsRepository,
    required this.examRepository,
  }) : super(HeadOfExamsDashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(HeadOfExamsDashboardLoading());
    try {
      final results = await Future.wait([
        headOfExamsRepository.getPublishableExams(),
        examRepository.getAllExams(),
      ]);

      final publishableResult = results[0];
      final allExamsResult = results[1];

      publishableResult.fold(
        (failure) => emit(HeadOfExamsDashboardFailure(failure.toString())),
        (publishableExams) {
          allExamsResult.fold(
            (failure) => emit(HeadOfExamsDashboardFailure(failure.toString())),
            (allExams) {
              // ✨ ---  منطق تجميع الإحصائيات حسب السنة --- ✨
              final Map<String, int> totalCounts = {};
              final Map<String, int> publishableCounts = {};

              for (var exam in allExams) {
                final year = exam.targetYear ?? 'غير محدد';
                totalCounts[year] = (totalCounts[year] ?? 0) + 1;
              }

              for (var exam in publishableExams) {
                final year = exam.targetYear ?? 'غير محدد';
                publishableCounts[year] = (publishableCounts[year] ?? 0) + 1;
              }

              final Map<String, YearExamStats> stats = {};
              totalCounts.forEach((year, total) {
                stats[year] = YearExamStats(
                  totalExams: total,
                  publishableExams: publishableCounts[year] ?? 0,
                );
              });

              emit(
                HeadOfExamsDashboardSuccess(
                  publishableExams: publishableExams,
                  statsByYear: stats,
                ),
              );
            },
          );
        },
      );
    } on Exception catch (e) {
      emit(HeadOfExamsDashboardFailure(e.toString()));
    }
  }
}
