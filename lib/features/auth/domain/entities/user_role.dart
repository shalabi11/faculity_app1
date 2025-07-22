// lib/features/auth/domain/entities/user_role.dart

enum UserRole {
  // الإدارة العليا
  dean, // عميد الكلية
  administrativeViceDean, // نائب العميد الإداري
  scientificViceDean, // نائب العميد العلمي
  // رؤساء الأقسام والمكاتب
  departmentHead, // رئيس قسم (أكاديمي)
  studentAffairsHead, // رئيس مكتب شؤون الطلاب
  examsOfficeHead, // رئيس مكتب إدارة الامتحانات
  // الموظفون
  studentAffairs, // موظف شؤون الطلاب
  examsOffice, // موظف مكتب الامتحانات
  selfService, // ذاتية (لم يتم تعريف واجهة لها بعد)
  // الهيئة التدريسية
  teacher, // دكتور
  teachingAssistant, // معيد
  // الأدوار الأساسية
  student,
  admin, // هذا الدور للدخول العام للمدراء
}
