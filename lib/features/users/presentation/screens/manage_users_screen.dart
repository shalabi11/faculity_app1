import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/widget/shimmer_loading.dart';
import 'package:faculity_app2/features/users/presentation/cubit/app_user_cubit.dart';
import 'package:faculity_app2/features/users/presentation/cubit/app_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppUserCubit>()..fetchUsers(),
      child: const _ManageUsersView(),
    );
  }
}

class _ManageUsersView extends StatelessWidget {
  const _ManageUsersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين')),
      body: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          if (state is AppUserLoading) {
            return const _LoadingList();
          }
          if (state is AppUserFailure) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }
          if (state is AppUserSuccess) {
            if (state.users.isEmpty) {
              return const Center(child: Text('لا يوجد مستخدمون لعرضهم.'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                IconData roleIcon;
                Color roleColor;
                switch (user.role) {
                  case 'admin':
                    roleIcon = Icons.admin_panel_settings_outlined;
                    roleColor = Colors.red.shade400;
                    break;
                  case 'teacher':
                    roleIcon = Icons.school_outlined;
                    roleColor = Colors.blue.shade400;
                    break;
                  case 'student':
                    roleIcon = Icons.person_outline;
                    roleColor = Colors.green.shade400;
                    break;
                  default:
                    roleIcon = Icons.help_outline;
                    roleColor = Colors.grey;
                }
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: roleColor.withOpacity(0.1),
                      child: Icon(roleIcon, color: roleColor),
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                    trailing: Text(
                      user.role,
                      style: TextStyle(
                        color: roleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.5);
          }
          return const Center(child: Text('ابدأ بتحميل المستخدمين.'));
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();
  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder:
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const ShimmerContainer.circular(size: 40),
                title: ShimmerContainer(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.3,
                ),
                subtitle: ShimmerContainer(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ),
      ),
    );
  }
}
