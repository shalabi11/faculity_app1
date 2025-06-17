import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  final User user;
  const AdminDashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // قائمة بخيارات الإدارة
    final List<DashboardItem> items = [
      DashboardItem(
        title: 'إدارة الإعلانات',
        icon: Icons.campaign_outlined,
        onTap: () {
          // TODO: Navigate to ManageAnnouncementsScreen
        },
      ),
      DashboardItem(
        title: 'إدارة الطلاب',
        icon: Icons.people_outline,
        onTap: () {},
      ),
      DashboardItem(
        title: 'إدارة المدرسين',
        icon: Icons.school_outlined,
        onTap: () {},
      ),
      DashboardItem(
        title: 'إدارة المواد',
        icon: Icons.book_outlined,
        onTap: () {},
      ),
      DashboardItem(
        title: 'إدارة الجداول',
        icon: Icons.calendar_today_outlined,
        onTap: () {},
      ),
      DashboardItem(
        title: 'إدارة الامتحانات',
        icon: Icons.event_note_outlined,
        onTap: () {},
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم الأدمن'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Add logout logic
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد الأعمدة
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2, // نسبة العرض إلى الارتفاع للبطاقة
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _DashboardCard(item: item);
        },
      ),
    );
  }
}

// كلاس مساعد لتمثيل كل عنصر في لوحة التحكم
class DashboardItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardItem({required this.title, required this.icon, required this.onTap});
}

// ويدجت لعرض بطاقة الإدارة
class _DashboardCard extends StatelessWidget {
  final DashboardItem item;
  const _DashboardCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
