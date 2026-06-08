import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/member_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, MemberEntity>> login({
    required String mobileNumber,
    required String password,
  });

  Future<Either<Failure, MemberEntity>> register({
    required String fullName,
    required String mobileNumber,
    required String password,
    String? district,
    String? thana,
    String? address,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, MemberEntity?>> getCurrentMember();
}