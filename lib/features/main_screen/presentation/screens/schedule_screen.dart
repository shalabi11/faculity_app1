// lib/features/main_screen/presentation/screens/schedule_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/widgets/schedule_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({
    super.key,
    required User user,
    required TabController tabController,
  });

  @override
  Widget build(BuildContext context) {
    // نقرأ حالة المصادقة للحصول على معلومات الطالب
    final authState = context.read<AuthCubit>().state;
    String? userYear;
    if (authState is Authenticated) {
      userYear = authState.user.year;
    }

    return BlocProvider(
      // --- التعديل هنا ---
      // نقوم بتمرير السنة الدراسية للطالب إلى الدالة
      create:
          (context) =>
              sl<ScheduleCubit>()..fetchTheorySchedule(
                year: userYear ?? 'first',
              ), // Provide a default year just in case
      child: Scaffold(
        appBar: AppBar(
          title: const Text('البرنامج الدراسي'),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state is ScheduleLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ScheduleFailure) {
              return Center(child: Text(state.message));
            } else if (state is ScheduleSuccess) {
              if (state.schedule.isEmpty) {
                return const Center(
                  child: Text('لا يوجد برنامج دراسي لعرضه حاليًا.'),
                );
              }
              return ScheduleListView(schedule: state.schedule, entries: []);
            }
            return const Center(child: Text('جاري تحميل الجدول...'));
          },
        ),
      ),
    );
  }
}
