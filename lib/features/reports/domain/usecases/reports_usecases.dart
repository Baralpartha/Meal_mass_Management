import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../dashboard/domain/entities/admin_dashbord_entity.dart';
import '../entities/cycle_member_summary_entity.dart';
import '../repositories/reports_repository.dart';

class GetCycleSummariesParams extends Equatable {
  final String cycleId;
  const GetCycleSummariesParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetCycleSummariesUseCase
    implements UseCase<List<CycleMemberSummaryEntity>, GetCycleSummariesParams> {
  final ReportsRepository _repository;
  GetCycleSummariesUseCase(this._repository);
  @override
  Future<Either<Failure, List<CycleMemberSummaryEntity>>> call(
          GetCycleSummariesParams params) =>
      _repository.getCycleSummaries(params.cycleId);
}

class GetMemberBalanceViewParams extends Equatable {
  final String cycleId;
  const GetMemberBalanceViewParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetMemberBalanceViewUseCase
    implements UseCase<List<MemberBalanceEntity>, GetMemberBalanceViewParams> {
  final ReportsRepository _repository;
  GetMemberBalanceViewUseCase(this._repository);
  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> call(
          GetMemberBalanceViewParams params) =>
      _repository.getMemberBalanceView(params.cycleId);
}

@lazySingleton
class GetAllMemberBalancesUseCase
    implements UseCaseNoParams<List<MemberBalanceEntity>> {
  final ReportsRepository _repository;
  GetAllMemberBalancesUseCase(this._repository);
  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> call() =>
      _repository.getAllMemberBalances();
}
