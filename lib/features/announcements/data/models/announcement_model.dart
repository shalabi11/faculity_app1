// lib/features/announcements/data/models/announcement_model.dart

import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.createdAt,
    super.userName,
    // super.attachmentUrl, // تأكد من إضافة هذا إذا كان موجوداً في الـ Entity
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      // --- التصحيحات النهائية هنا ---

      // التعامل مع احتمالية أن يكون الـ ID فارغاً
      id: json['id'] ?? 0,

      // إذا كان العنوان فارغاً، استخدم "بدون عنوان"
      title: json['title'] ?? 'بدون عنوان',

      // إذا كان المحتوى فارغاً، استخدم "لا يوجد محتوى"
      content: json['content'] ?? 'لا يوجد محتوى',

      // التعامل مع التاريخ الفارغ بشكل آمن جداً
      createdAt:
          json['created_at'] == null
              ? DateTime.now() // إذا كان التاريخ فارغاً، استخدم تاريخ الآن
              : DateTime.parse(json['created_at']),

      userName: json['user_name'],
      // attachmentUrl: json['attachment'],
    );
  }
}
