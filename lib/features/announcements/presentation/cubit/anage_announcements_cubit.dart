import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/manage_announcements_state.dart';


class ManageAnnouncementsCubit extends Cubit<ManageAnnouncementsState> {
  final AnnouncementRepository repository;
  ManageAnnouncementsCubit({required this.repository})
    : super(ManageAnnouncementsInitial());

  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  }) async {
    try {
      emit(ManageAnnouncementsLoading());
      await repository.addAnnouncement(data: data, filePath: filePath);
      emit(ManageAnnouncementsSuccess('تم إضافة الإعلان بنجاح.'));
    } on Exception catch (e) {
      emit(ManageAnnouncementsFailure(e.toString()));
    }
  }

  Future<void> updateAnnouncement({
    required int id,
    required Map<String, String> data,
  }) async {
    try {
      emit(ManageAnnouncementsLoading());
      await repository.updateAnnouncement(id: id, data: data);
      emit(ManageAnnouncementsSuccess('تم تعديل الإعلان بنجاح.'));
    } on Exception catch (e) {
      emit(ManageAnnouncementsFailure(e.toString()));
    }
  }

  Future<void> deleteAnnouncement({required int id}) async {
    try {
      emit(ManageAnnouncementsLoading());
      await repository.deleteAnnouncement(id: id);
      emit(ManageAnnouncementsSuccess('تم حذف الإعلان بنجاح.'));
    } on Exception catch (e) {
      emit(ManageAnnouncementsFailure(e.toString()));
    }
  }
}
