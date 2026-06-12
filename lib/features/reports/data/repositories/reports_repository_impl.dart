import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../dashboard/domain/entities/admin_dashbord_entity.dart';
import '../../domain/entities/cycle_member_summary_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource _remote;
  ReportsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<CycleMemberSummaryEntity>>> getCycleSummaries(
      String cycleId) async {
    try {
      final models = await _remote.getCycleSummaries(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> getMemberBalanceView(
      String cycleId) async {
    try {
      final models = await _remote.getMemberBalanceView(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> getAllMemberBalances() async {
    try {
      final models = await _remote.getAllMemberBalances();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
