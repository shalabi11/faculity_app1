// lib/features/announcements/domain/entities/announcement.dart
class Announcement {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final String? attachmentUrl; // قد يكون هناك مرفق وقد لا يكون

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.attachmentUrl,
  });
}
