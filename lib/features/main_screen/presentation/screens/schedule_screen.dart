import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:faculity_app2/features/schedule/presentation/widgets/schedule_list_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// استخدام TickerProviderStateMixin ضروري للتحكم في الـ TabController
class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // نستخدم AppBar هنا بدلًا من AppBar الخاص بـ StudentMainScreen
      // لكي نضع الـ TabBar بداخله
      appBar: AppBar(
        // إزالة العنوان لأن العنوان موجود في الشاشة الرئيسية
        // title: const Text('الجدول الدراسي'),
        centerTitle: true,
        // إزالة زر الرجوع التلقائي
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'الجدول النظري'), Tab(text: 'الجدول العملي')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // عرض تبويب الجدول النظري
          ScheduleTabView(scheduleType: ScheduleType.theory),
          // عرض تبويب الجدول العملي
          ScheduleTabView(scheduleType: ScheduleType.lab),
        ],
      ),
    );
  }
}

// Enum لتحديد نوع الجدول المطلوب
enum ScheduleType { theory, lab }

// ويدجت لعرض محتوى كل تبويب على حدة
class ScheduleTabView extends StatelessWidget {
  final ScheduleType scheduleType;

  const ScheduleTabView({super.key, required this.scheduleType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // إنشاء Cubit جديد لكل تبويب
      create: (context) => sl<ScheduleCubit>()..fetchTheorySchedule('أولى'),
      // TODO: يجب الحصول على سنة وفئة الطالب الحقيقي لاحقًا
      // ..(scheduleType == ScheduleType.theory
      //     ? fetchTheorySchedule('first_year') // استبدل بالسنة الحقيقية
      //     : fetchLabSchedule('A')), // استبدل بالفئة الحقيقية
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ScheduleError) {
            return Center(child: Text('خطأ: ${state.message}'));
          }
          if (state is ScheduleLoaded) {
            if (state.schedule.isEmpty) {
              return const Center(child: Text('لا يوجد بيانات لعرضها'));
            }
            // استخدام ويدجت منفصل لعرض القائمة لجعل الكود أنظف
            return ScheduleListView(entries: state.schedule);
          }
          return const Center(child: Text('اسحب لتحديث الجدول'));
        },
      ),
    );
  }
}
