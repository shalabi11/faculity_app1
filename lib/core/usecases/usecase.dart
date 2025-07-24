import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';

// هذا هو العقد الأساسي لكل الـ UseCases في التطبيق
// Type: هو نوع البيانات التي ستعود في حالة النجاح
// Params: هو نوع المدخلات التي سيأخذها الـ UseCase
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// هذا الكلاس نستخدمه عندما لا يحتاج الـ UseCase إلى أي مدخلات
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
