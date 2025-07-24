// import 'package:faculity_app2/features/student_affairs/presentation/screens/students_by_year_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:faculity_app2/core/services/service_locator.dart';
// import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
// import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
// import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
// // ملاحظة: تأكد من أن لديك هذه الشاشة، أو قم بالتعليق على السطر التالي مؤقتاً
// // import 'package:faculity_app2/features/student_affairs/presentation/screens/students_by_year_screen.dart';

// class StudentAffairsDashboardScreen extends StatefulWidget {
//   const StudentAffairsDashboardScreen({super.key});

//   @override
//   State<StudentAffairsDashboardScreen> createState() =>
//       _StudentAffairsDashboardScreenState();
// }

// class _StudentAffairsDashboardScreenState
//     extends State<StudentAffairsDashboardScreen> {
//   @override
//   void initState() {
//     super.initState();
//     //  -- التعديل الأول: اسم الدالة --
//     // جلب البيانات عند فتح الشاشة
//     context.read<StudentAffairsCubit>().fetchStudentDashboardData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = [
//       Colors.blue.shade300,
//       Colors.green.shade300,
//       Colors.orange.shade300,
//       Colors.purple.shade300,
//       Colors.red.shade300,
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'لوحة تحكم شؤون الطلاب',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.teal.shade700,
//         elevation: 4,
//       ),
//       body: BlocBuilder<StudentAffairsCubit, StudentAffairsState>(
//         builder: (context, state) {
//           if (state is StudentAffairsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is StudentAffairsLoaded) {
//             // -- التعديل الثاني: طريقة الوصول للبيانات --
//             final years = state.dashboardEntity.studentsByYear.keys.toList();
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<StudentAffairsCubit>().fetchStudentDashboardData();
//               },
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(16),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 1.2,
//                 ),
//                 itemCount: years.length,
//                 itemBuilder: (context, index) {
//                   final year = years[index];
//                   final count = state.dashboardEntity.studentsByYear[year] ?? 0;
//                   return _buildYearCard(
//                     context,
//                     year,
//                     count,
//                     colors[index % colors.length],
//                   );
//                 },
//               ),
//             );
//           } else if (state is StudentAffairsError) {
//             return Center(child: Text(state.message));
//           }
//           return const Center(child: Text('يرجى تحديث البيانات'));
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (_) => BlocProvider(
//                     create: (context) => sl<ManageStudentCubit>(),
//                     child: const AddStudentScreen(),
//                   ),
//             ),
//           );

//           if (result == true) {
//             // -- التعديل الثالث: اسم الدالة --
//             if (mounted) {
//               context.read<StudentAffairsCubit>().fetchStudentDashboardData();
//             }
//           }
//         },
//         backgroundColor: Colors.teal.shade800,
//         tooltip: 'إضافة طالب جديد',
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildYearCard(
//     BuildContext context,
//     String year,
//     int count,
//     Color color,
//   ) {
//     return InkWell(
//       onTap: () {
//         // يمكنك هنا الانتقال إلى شاشة عرض الطلاب الخاصة بهذه السنة
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StudentsByYearScreen(year: year, students: []),
//           ),
//         );
//       },
//       borderRadius: BorderRadius.circular(20),
//       child: Card(
//         elevation: 6,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: color,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'السنة $year',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     count.toString(),
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   const Icon(Icons.person, color: Colors.white, size: 30),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart'
    as affairs;
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/students_by_year_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentAffairsDashboardScreen extends StatefulWidget {
  const StudentAffairsDashboardScreen({super.key});

  @override
  State<StudentAffairsDashboardScreen> createState() =>
      _StudentAffairsDashboardScreenState();
}

class _StudentAffairsDashboardScreenState
    extends State<StudentAffairsDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند فتح الشاشة
    BlocProvider.of<StudentAffairsCubit>(context).fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.red.shade300,
    ];

    return BlocProvider(
      create: (context) => di.sl<affairs.AddStudentCubit>(),
      child: BlocListener<affairs.AddStudentCubit, affairs.AddStudentState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is affairs.AddStudentSuccess) {
            // إذا تمت الإضافة بنجاح، أعد تحميل بيانات الداشبورد
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تمت إضافة الطالب بنجاح!')),
            );
            // استدعاء الـ Cubit الخاص بالداشبورد لتحديث البيانات
            context.read<StudentAffairsCubit>().fetchDashboardData();
          } else if (state is affairs.AddStudentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل في إضافة الطالب: ${state.message}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'لوحة تحكم شؤون الطلاب',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.teal.shade700,
            elevation: 4,
          ),
          body: BlocBuilder<StudentAffairsCubit, StudentAffairsState>(
            builder: (context, state) {
              if (state is StudentAffairsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StudentAffairsLoaded) {
                final years = state.dashboardData.studentsByYear.keys.toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    // الكود الصحيح
                    final students =
                        state.dashboardData.studentsByYear[year] ?? [];
                    return _buildYearCard(
                      context,
                      year,

                      students,
                      colors[index % colors.length],
                    );
                  },
                );
              } else if (state is StudentAffairsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<StudentAffairsCubit>()
                              .fetchDashboardData();
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: Text('يرجى تحديث البيانات'));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // نستخدم async و await هنا لنتمكن من انتظار نتيجة الشاشة التالية
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        // يقوم بإنشاء نسخة جديدة من الـ Cubit وتوفيرها للشاشة
                        create: (context) => sl<affairs.AddStudentCubit>(),
                        child: const AddStudentScreen(),
                      ),
                ),
              );

              // إذا تمت إضافة الطالب بنجاح، فإن الشاشة ستعود بنتيجة 'true'
              // عندها نقوم بتحديث بيانات الداشبورد لإظهار العدد الجديد للطلاب
              if (result == true && mounted) {
                // ignore: use_build_context_synchronously
                context.read<StudentAffairsCubit>().fetchDashboardData();
              }
            },
            backgroundColor: Colors.teal.shade800,
            tooltip: 'إضافة طالب جديد',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildYearCard(
    BuildContext context,
    String year,
    // int count,
    List<StudentModel> students,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => StudentsByYearScreen(year: year, students: students),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'السنة $year',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    students.length.toString(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.person, color: Colors.white, size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
