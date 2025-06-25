import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';

abstract class AnnouncementState {
  // وضع قائمة الإعلانات هنا يجعلها متاحة في كل الحالات
  final List<Announcement> announcements;
  const AnnouncementState({this.announcements = const []});
}

class AnnouncementInitial extends AnnouncementState {}

// حالة التحميل الآن تحتوي على قائمة الإعلانات القديمة (إن وجدت)
// هذا مفيد عند عمل "تحديث بالسحب" لعرض البيانات القديمة أثناء جلب الجديدة
class AnnouncementLoading extends AnnouncementState {
  const AnnouncementLoading({super.announcements});
}

class AnnouncementLoaded extends AnnouncementState {
  const AnnouncementLoaded(List<Announcement> announcements)
    : super(announcements: announcements);
}

class AnnouncementError extends AnnouncementState {
  final String message;
  const AnnouncementError(this.message);
}

class AnnouncementSucces extends AnnouncementState {}
