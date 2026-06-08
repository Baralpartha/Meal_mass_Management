import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../../domain/repositories/members_repository.dart';
import '../datasources/members_remote_datasource.dart';

@LazySingleton(as: MembersRepository)
class MembersRepositoryImpl implements MembersRepository {
  final MembersRemoteDataSource _remote;

  MembersRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<MemberEntity>>> getAllMembers() async {
    try {
      final models = await _remote.getAllMembers();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberEntity>>> getMembersByStatus(
      String status) async {
    try {
      final models = await _remote.getMembersByStatus(status);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> approveMember(
      {required String adminId, required String memberId}) async {
    try {
      final result = await _remote.approveMember(
          adminId: adminId, memberId: memberId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rejectMember(
      {required String adminId, required String memberId}) async {
    try {
      final result =
      await _remote.rejectMember(adminId: adminId, memberId: memberId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MemberEntity>> getMemberById(
      String memberId) async {
    try {
      final model = await _remote.getMemberById(memberId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}