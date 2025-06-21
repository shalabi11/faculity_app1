


abstract class ManageAnnouncementsState {}

class ManageAnnouncementsInitial extends ManageAnnouncementsState {}

class ManageAnnouncementsLoading extends ManageAnnouncementsState {}

class ManageAnnouncementsSuccess extends ManageAnnouncementsState {
  final String message;
  ManageAnnouncementsSuccess(this.message);
}

class ManageAnnouncementsFailure extends ManageAnnouncementsState {
  final String message;
  ManageAnnouncementsFailure(this.message);
}
