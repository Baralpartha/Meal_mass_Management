import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../repositories/members_repository.dart';

// ── Get All Members ───────────────────────────────────────────────────────

@lazySingleton
class GetAllMembersUseCase implements UseCaseNoParams<List<MemberEntity>> {
  final MembersRepository _repository;
  GetAllMembersUseCase(this._repository);

  @override
  Future<Either<Failure, List<MemberEntity>>> call() =>
      _repository.getAllMembers();
}

// ── Get Members By Status ─────────────────────────────────────────────────

class GetMembersByStatusParams extends Equatable {
  final String status;
  const GetMembersByStatusParams(this.status);
  @override
  List<Object?> get props => [status];
}

@lazySingleton
class GetMembersByStatusUseCase
    implements UseCase<List<MemberEntity>, GetMembersByStatusParams> {
  final MembersRepository _repository;
  GetMembersByStatusUseCase(this._repository);

  @override
  Future<Either<Failure, List<MemberEntity>>> call(
      GetMembersByStatusParams params) =>
      _repository.getMembersByStatus(params.status);
}

// ── Approve Member ────────────────────────────────────────────────────────

class ApproveMemberParams extends Equatable {
  final String adminId;
  final String memberId;
  const ApproveMemberParams({required this.adminId, required this.memberId});
  @override
  List<Object?> get props => [adminId, memberId];
}

@lazySingleton
class ApproveMemberUseCase implements UseCase<String, ApproveMemberParams> {
  final MembersRepository _repository;
  ApproveMemberUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(ApproveMemberParams params) =>
      _repository.approveMember(
          adminId: params.adminId, memberId: params.memberId);
}

// ── Reject Member ─────────────────────────────────────────────────────────

class RejectMemberParams extends Equatable {
  final String adminId;
  final String memberId;
  const RejectMemberParams({required this.adminId, required this.memberId});
  @override
  List<Object?> get props => [adminId, memberId];
}

@lazySingleton
class RejectMemberUseCase implements UseCase<String, RejectMemberParams> {
  final MembersRepository _repository;
  RejectMemberUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(RejectMemberParams params) =>
      _repository.rejectMember(
          adminId: params.adminId, memberId: params.memberId);
}

// ── Get Member By ID ──────────────────────────────────────────────────────

class GetMemberByIdParams extends Equatable {
  final String memberId;
  const GetMemberByIdParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetMemberByIdUseCase implements UseCase<MemberEntity, GetMemberByIdParams> {
  final MembersRepository _repository;
  GetMemberByIdUseCase(this._repository);

  @override
  Future<Either<Failure, MemberEntity>> call(GetMemberByIdParams params) =>
      _repository.getMemberById(params.memberId);
}