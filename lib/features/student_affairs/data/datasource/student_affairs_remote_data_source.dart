import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _studentsEndpoint = '/students';

abstract class StudentAffairsRemoteDataSource {
  Future<Map<String, List<StudentModel>>> getStudentDashboardData();
  Future<Unit> addStudent(StudentModel student, File? image);
}

class StudentAffairsRemoteDataSourceImpl
    implements StudentAffairsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  StudentAffairsRemoteDataSourceImpl({
    required this.dio,
    required this.secureStorage,
  });
  // في ملف student_affairs_remote_data_source.dart

  @override
  Future<Map<String, List<StudentModel>>> getStudentDashboardData() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/students',
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> studentsJsonList = response.data;
        final List<StudentModel> studentsList =
            studentsJsonList
                .map((json) => StudentModel.fromJson(json))
                .toList();

        // إنشاء خريطة لتجميع الطلاب حسب السنة
        final Map<String, List<StudentModel>> studentsByYear = {
          'الاولى': [],
          'الثانية': [],
          'الثالثة': [],
          'الرابعة': [],
          'الخامسة': [],
        };

        // المرور على كل طالب وإضافته إلى القائمة الصحيحة
        for (var student in studentsList) {
          if (studentsByYear.containsKey(student.year)) {
            studentsByYear[student.year]!.add(student);
          }
        }
        return studentsByYear;
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة.');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'فشل الاتصال بالخادم.');
    }
  }

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<Unit> addStudent(StudentModel student, File? image) async {
    // 1. تحويل كائن الطالب إلى خريطة (Map) لإرسالها
    final studentData = {
      'university_id': student.universityId,
      'full_name': student.fullName,
      'mother_name': student.motherName,
      'birth_date': student.birthDate,
      'birth_place': student.birthPlace,
      'department': student.department,
      'year': student.year,
      'high_school_gpa': student.highSchoolGpa.toString(),
    };

    try {
      // 2. إنشاء FormData لإرسال البيانات والصورة معاً
      final formData = FormData.fromMap(studentData);
      if (image != null) {
        formData.files.add(
          MapEntry('profile_image', await MultipartFile.fromFile(image.path)),
        );
      }

      // 3. إرسال الطلب إلى الخادم
      await dio.post(
        '$baseUrl/api/students',
        data: formData,
        options: await _getAuthHeaders(), // استخدام التوكن للمصادقة
      );

      // 4. إرجاع Unit.unit للإشارة إلى نجاح العملية
      return unit;
    } on DioException catch (e) {
      // 5. معالجة الأخطاء في حال فشل الطلب
      handleDioException(e);
      // لن يتم الوصول لهذا السطر عادةً لأن الدالة السابقة سترمي الخطأ
      throw ServerException(message: 'فشل في إرسال البيانات');
    }
  }
}
