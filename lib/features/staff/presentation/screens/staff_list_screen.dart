import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_state.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_state.dart';
import 'package:faculity_app2/features/staff/presentation/screens/add_edit_staff_screen.dart';

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استخدام MultiBlocProvider لتوفير كلا الـ Cubits
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<StaffCubit>()..fetchStaff()),
        BlocProvider(create: (context) => di.sl<ManageStaffCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('قائمة الموظفين'), centerTitle: true),
        // 2. استخدام BlocListener للاستماع لنتائج الحذف
        body: BlocListener<ManageStaffCubit, ManageStaffState>(
          listener: (context, state) {
            if (state is ManageStaffSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تمت العملية بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              // بعد نجاح الحذف، نطلب تحديث القائمة
              context.read<StaffCubit>().fetchStaff();
            } else if (state is ManageStaffFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('فشل: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<StaffCubit, StaffState>(
            builder: (context, state) {
              if (state is StaffLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StaffLoaded) {
                return _buildStaffList(context, state.staff);
              } else if (state is StaffError) {
                return Center(
                  child: Text('فشل في جلب البيانات: ${state.message}'),
                );
              }
              return const Center(child: Text('جاري بدء التحميل...'));
            },
          ),
        ),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditStaffScreen(),
                    ),
                  ).then((result) {
                    if (result == true) {
                      context.read<StaffCubit>().fetchStaff();
                    }
                  });
                },
                backgroundColor: Colors.teal,
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }

  Widget _buildStaffList(BuildContext context, List<StaffEntity> staffList) {
    if (staffList.isEmpty) {
      return const Center(child: Text('لا يوجد موظفين لعرضهم.'));
    }
    return ListView.builder(
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staffMember = staffList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
          child: ListTile(
            title: Text(
              staffMember.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('القسم: ${staffMember.department}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
                  onPressed: () {
                    // --- قم بتفعيل هذا الكود ---
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // الانتقال إلى شاشة التعديل مع تمرير بيانات الموظف
                        builder:
                            (_) => AddEditStaffScreen(staffMember: staffMember),
                      ),
                    ).then((result) {
                      // إذا تم التعديل بنجاح، قم بتحديث القائمة
                      if (result == true) {
                        context.read<StaffCubit>().fetchStaff();
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  onPressed: () {
                    // 3. إظهار حوار التأكيد واستدعاء دالة الحذف
                    showDialog(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: Text(
                              'هل أنت متأكد من رغبتك في حذف الموظف ${staffMember.fullName}؟',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('إلغاء'),
                                onPressed:
                                    () => Navigator.of(dialogContext).pop(),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('حذف'),
                                onPressed: () {
                                  context.read<ManageStaffCubit>().deleteStaff(
                                    staffMember.id,
                                  );
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
