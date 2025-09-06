// lib/features/staff/presentation/screens/staff_list_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_state.dart';
import 'package:faculity_app2/features/staff/presentation/screens/add_edit_staff_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffListScreen extends StatelessWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StaffCubit>()..fetchStaff(),
      child: const _StaffListView(),
    );
  }
}

// ✨ 1. تحويل الويدجت إلى StatefulWidget
class _StaffListView extends StatefulWidget {
  const _StaffListView();

  @override
  State<_StaffListView> createState() => _StaffListViewState();
}

class _StaffListViewState extends State<_StaffListView> {
  // ✨ 2. متغيرات لإدارة حالة البحث
  final _searchController = TextEditingController();
  List<StaffEntity> _allStaff = [];
  List<StaffEntity> _filteredStaff = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterStaff);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStaff);
    _searchController.dispose();
    super.dispose();
  }

  // ✨ 3. دالة لفلترة قائمة الموظفين
  void _filterStaff() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStaff =
          _allStaff.where((staff) {
            return staff.fullName.toLowerCase().contains(query);
          }).toList();
    });
  }

  void _refreshData() {
    context.read<StaffCubit>().fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الموظفين')),
      body: Column(
        children: [
          // ✨ 4. إضافة حقل البحث في الواجهة
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن موظف...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<StaffCubit, StaffState>(
              listener: (context, state) {
                if (state is StaffLoaded) {
                  setState(() {
                    _allStaff = state.staff;
                    _filteredStaff = state.staff;
                    _filterStaff();
                  });
                }
              },
              builder: (context, state) {
                if (state is StaffLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is StaffError) {
                  return Center(child: Text('خطأ: ${state.message}'));
                }
                if (state is StaffLoaded) {
                  if (_filteredStaff.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد موظفون يطابقون بحثك.'),
                    );
                  }
                  // ✨ 5. استخدام القائمة المفلترة للعرض
                  return ListView.builder(
                    itemCount: _filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staffMember = _filteredStaff[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(staffMember.fullName[0]),
                          ),
                          title: Text(staffMember.fullName),
                          subtitle: Text(staffMember.department),
                          onTap: () {
                            // يمكنك هنا الانتقال لصفحة تفاصيل الموظف
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditStaffScreen()),
          ).then((_) => _refreshData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
