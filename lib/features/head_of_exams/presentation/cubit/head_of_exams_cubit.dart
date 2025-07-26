import 'package:faculity_app2/features/head_of_exams/domain/repository/head_of_exams_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/cubit/head_of_exams_state.dart';

class HeadOfExamsCubit extends Cubit<HeadOfExamsState> {
  final HeadOfExamsRepository repository;

  HeadOfExamsCubit({required this.repository}) : super(HeadOfExamsInitial());

  Future<void> fetchPublishableExams() async {
    emit(HeadOfExamsLoading());
    final result = await repository.getPublishableExams();
    result.fold(
      (failure) => emit(HeadOfExamsFailure(failure.toString())),
      (exams) => emit(HeadOfExamsLoaded(exams)),
    );
  }

  Future<void> publishResults(int examId) async {
    emit(PublishingResults());
    final result = await repository.publishExamResults(examId);
    result.fold((failure) => emit(HeadOfExamsFailure(failure.toString())), (_) {
      emit(const PublishSuccess('تم نشر النتائج بنجاح!'));
      // إعادة تحميل القائمة بعد النشر
      fetchPublishableExams();
    });
  }
}
