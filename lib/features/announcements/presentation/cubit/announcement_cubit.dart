import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_state.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final AnnouncementRepository repository;

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
