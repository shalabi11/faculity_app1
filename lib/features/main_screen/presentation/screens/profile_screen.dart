import 'package:faculity_app2/core/theme/app_color.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SplashView()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        // استخدام CustomScrollView يسمح بمرونة أكبر في التصميم
        body: CustomScrollView(
          slivers: [
            _ProfileHeader(user: user),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                // تطبيق الأنيميشن على كل بطاقة
                _InfoCard(
                  title: 'المعلومات الأكاديمية',
                  icon: Icons.school_outlined,
                  children: [
                    _InfoTile(
                      icon: Icons.school_outlined,
                      title: 'الرقم الجامعي',
                      value: user.id.toString(),
                    ),
                    _InfoTile(
                      icon: Icons.class_outlined,
                      title: 'السنة',
                      value: user.year ?? 'N/A',
                    ),
                    _InfoTile(
                      icon: Icons.group_outlined,
                      title: 'الفئة',
                      value: user.section ?? 'N/A',
                    ),
                  ],
                ).animate().fade(delay: 200.ms).slideX(begin: -0.2),

                const SizedBox(height: 20),
                _ActionsSection()
                    .animate()
                    .fade(delay: 300.ms)
                    .slideY(begin: 0.5),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ===============================================
//  ويدجت الهيدر الديناميكي الجديد
// ===============================================
class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.card,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    ), // مسافة لإفساح المجال للاسم في الأسفل
                  ],
                ),
              ),
            ],
          ),
        ).animate().fade(duration: 600.ms),
      ),
    );
  }
}

// ===============================================
//  ويدجت بطاقة المعلومات القابلة للطي
// ===============================================
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
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: ExpansionTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          children: children,
        ),
      ),
    );
  }
}

// ===============================================
//  ويدجت عرض معلومة واحدة (مُحسّن)
// ===============================================
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ===============================================
//  ويدجت زر تسجيل الخروج
// ===============================================
class _ActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (dialogContext) => AlertDialog(
                  title: const Text('تأكيد'),
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
