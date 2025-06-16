// lib/features/announcements/data/models/announcement_model.dart
import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    required int id,
    required String title,
    required String content,
    required String createdAt,
    String? attachmentUrl,
  }) : super(
         id: id,
         title: title,
         content: content,
         createdAt: createdAt,
         attachmentUrl: attachmentUrl,
       );

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'],
      attachmentUrl: json['attachment'], // اسم الحقل في الـ API
    );
  }
}
