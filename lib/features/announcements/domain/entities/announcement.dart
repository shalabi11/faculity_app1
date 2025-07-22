// lib/features/announcements/domain/entities/announcement.dart
import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? userName;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.userName,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, userName];
}
