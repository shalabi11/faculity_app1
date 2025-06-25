// lib/features/announcements/data/models/announcement_model.dart

import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    super.createdAt, // <-- تم تغيير النوع إلى DateTime اختياري
    super.attachmentUrl,
    super.userName, // <-- تمت إضافته
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      // --- التعديلات الجذرية هنا ---
      id: json['id'], // الـ ID هو رقم بالفعل، لا حاجة للتحويل
      title: json['title'] ?? 'بدون عنوان',
      content: json['content'] ?? 'لا يوجد محتوى',

      // نقرأ اسم المستخدم الجديد
      userName: json['user_name'],

      // نتحقق من وجود حقل التاريخ قبل تحويله
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,

      attachmentUrl: json['attachment'],
    );
  }
}
