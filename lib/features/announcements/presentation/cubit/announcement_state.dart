import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Announcement> announcements;
  AnnouncementLoaded(this.announcements);
}

class AnnouncementError extends AnnouncementState {
  final String message;
  AnnouncementError(this.message);
}
