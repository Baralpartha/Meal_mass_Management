import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/member_entity.dart';

abstract class MembersRepository {
  Future<Either<Failure, List<MemberEntity>>> getAllMembers();
  Future<Either<Failure, List<MemberEntity>>> getMembersByStatus(String status);
  Future<Either<Failure, String>> approveMember(
      {required String adminId, required String memberId});
  Future<Either<Failure, String>> rejectMember(
      {required String adminId, required String memberId});
  Future<Either<Failure, MemberEntity>> getMemberById(String memberId);
}