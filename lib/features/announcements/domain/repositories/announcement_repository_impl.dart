// lib/features/announcements/data/repositories/announcement_repository_impl.dart
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/announcements/data/datasources/announcement_remote_data_source.dart';

import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Announcement>> getAnnouncements() async {
    try {
      return await remoteDataSource.getAnnouncements();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }
}
