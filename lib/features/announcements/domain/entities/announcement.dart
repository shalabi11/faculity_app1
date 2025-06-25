// lib/features/announcements/domain/entities/announcement.dart

class Announcement {
  final int id;
  final String title;
  final String content;
  final DateTime? createdAt; // <-- أصبح اختياريًا
  final String? attachmentUrl;
  final String? userName; // <-- تمت إضافته

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    this.createdAt, // <-- أصبح اختياريًا
    this.attachmentUrl,
    this.userName, // <-- تمت إضافته
  });
}
