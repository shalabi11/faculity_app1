// الكود الصحيح
import 'package:bloc/bloc.dart';
import '../../domain/repositories/announcement_repository.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository repository;

  // قمنا بحذف البارامتر المكرر والخاطئ
  AnnouncementCubit({required this.repository}) : super(AnnouncementInitial());

  Future<void> fetchAnnouncements() async {
    try {
      emit(AnnouncementLoading());
      final announcements = await repository.getAnnouncements();
      emit(AnnouncementLoaded(announcements));
    } on Exception catch (e) {
      emit(AnnouncementError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
