// lib/features/announcements/domain/repositories/announcement_repository.dart
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();
}
