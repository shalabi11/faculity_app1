// lib/features/main_screen/presentation/screens/profile_screen.dart

import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
// --- تأكد من أن هذا هو المسار الصحيح لشاشة تسجيل الدخول ---
import 'package:faculity_app2/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // --- التصحيح الجذري هنا ---
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // بدلاً من الانتقال إلى SplashView، ننتقل مباشرة إلى LoginScreen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false, // هذا السطر يضمن مسح كل الشاشات السابقة
          );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _ProfileHeader(user: user),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                _InfoCard(
                  title: 'المعلومات الأكاديمية',
                  icon: Icons.school_outlined,
                  children: [
                    _InfoTile(
                      icon: Icons.person_pin_rounded,
                      title: 'الرقم الجامعي',
                      value: '000',
                    ),
                    _InfoTile(
                      icon: Icons.class_outlined,
                      title: 'السنة الدراسية',
                      value: user.year ?? 'الرابعة',
                    ),
                    _InfoTile(
                      icon: Icons.group_work_outlined,
                      title: 'الفئة',
                      value: user.section ?? 'غير محددة',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ActionsSection(),
                const SizedBox(height: 30),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ... باقي كود الواجهة (_ProfileHeader, _InfoCard, _InfoTile, _ActionsSection) يبقى كما هو بدون تغيير ...

class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Center(
          child: CircleAvatar(
            radius: 55,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
        ).animate().scale(delay: 100.ms),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const Divider(height: 24),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: TextButton.icon(
        icon: const Icon(Icons.logout_rounded),
        label: const Text('تسجيل الخروج'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (dialogContext) => AlertDialog(
                  title: const Text('تأكيد الخروج'),
                  content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text(
                        'خروج',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }
}
