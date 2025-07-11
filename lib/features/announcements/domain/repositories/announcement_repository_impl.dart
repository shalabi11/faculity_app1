// lib/features/announcements/data/repositories/announcement_repository_impl.dart
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/announcements/data/datasources/announcement_remote_data_source.dart';

import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({required this.remoteDataSource});

  // ======================= التعديل الأول هنا =======================
  @override
  Future<List<Announcement>> getAnnouncements() async {
    try {
      return await remoteDataSource.getAnnouncements();
    } on ServerException catch (e) {
      // تمرير رسالة الخطأ المحددة من الخادم
      throw Exception(e.message);
    } catch (e) {
      // تمرير تفاصيل الخطأ العام بدلاً من إخفائه
      throw Exception('حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  // ======================= التعديل الثاني هنا =======================
  @override
  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  }) async {
    try {
      await remoteDataSource.addAnnouncement(data: data, filePath: filePath);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('فشل إضافة الإعلان: ${e.toString()}');
    }
  }

  // ======================= التعديل الثالث هنا =======================
  @override
  Future<void> updateAnnouncement({
    required int id,
    required Map<String, String> data,
  }) async {
    try {
      await remoteDataSource.updateAnnouncement(id: id, data: data);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('فشل تعديل الإعلان: ${e.toString()}');
    }
  }

  // ======================= التعديل الرابع هنا =======================
  @override
  Future<void> deleteAnnouncement({required int id}) async {
    try {
      await remoteDataSource.deleteAnnouncement(id: id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('فشل حذف الإعلان: ${e.toString()}');
    }
  }
}
