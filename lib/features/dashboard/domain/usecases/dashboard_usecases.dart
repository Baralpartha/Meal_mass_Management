import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_dashbord_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetAdminDashboardParams extends Equatable {
  final String adminId;
  const GetAdminDashboardParams(this.adminId);
  @override
  List<Object?> get props => [adminId];
}

@lazySingleton
class GetAdminDashboardUseCase
    implements UseCase<AdminDashboardEntity, GetAdminDashboardParams> {
  final DashboardRepository _repository;
  GetAdminDashboardUseCase(this._repository);
  @override
  Future<Either<Failure, AdminDashboardEntity>> call(
          GetAdminDashboardParams params) =>
      _repository.getAdminDashboard(params.adminId);
}

class GetMemberDashboardParams extends Equatable {
  final String memberId;
  const GetMemberDashboardParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetMemberDashboardUseCase
    implements UseCase<List<MemberBalanceEntity>, GetMemberDashboardParams> {
  final DashboardRepository _repository;
  GetMemberDashboardUseCase(this._repository);
  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> call(
          GetMemberDashboardParams params) =>
      _repository.getMemberDashboard(params.memberId);
}
