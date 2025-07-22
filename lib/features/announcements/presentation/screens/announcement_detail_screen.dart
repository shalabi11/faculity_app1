import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';

import 'package:flutter/material.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(announcement.title, overflow: TextOverflow.ellipsis),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // عنوان الإعلان
          Text(
            announcement.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // تاريخ النشر
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 8),
              Text(
                'نُشر في: ${announcement.createdAt}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const Divider(height: 30),
          // محتوى الإعلان
          Text(
            announcement.content,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.6, fontSize: 16),
          ),
          const SizedBox(height: 30),
          // عرض المرفق إن وجد
          // if (announcement.attachmentUrl != null &&
          //     announcement.attachmentUrl!.isNotEmpty)
          //   _AttachmentWidget(url: announcement.attachmentUrl!),
        ],
      ),
    );
  }
}

// ويدجت لعرض المرفقات
class _AttachmentWidget extends StatelessWidget {
  final String url;
  const _AttachmentWidget({required this.url});

  @override
  Widget build(BuildContext context) {
    // يمكنك هنا إضافة منطق لفتح الرابط أو عرض الصورة
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المرفقات:',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: const Icon(Icons.attach_file, color: AppColors.primary),
            title: const Text('عرض المرفق'),
            onTap: () {
              // TODO: Add logic to open the attachment URL using a package like `url_launcher`
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening attachment: $url')),
              );
            },
          ),
        ),
      ],
    );
  }
}
