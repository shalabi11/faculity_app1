// lib/features/announcements/domain/repositories/announcement_repository.dart
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();
  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  });
  Future<void> updateAnnouncement({
    required int id,
    required Map<String, String> data,
  });
  Future<void> deleteAnnouncement({required int id});
}
