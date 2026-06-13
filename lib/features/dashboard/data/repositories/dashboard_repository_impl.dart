import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/admin_dashbord_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remote;
  DashboardRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AdminDashboardEntity>> getAdminDashboard(
      String adminId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('➡️ Repository: Fetching Admin Dashboard for ID: "$adminId"');

      final model = await _remote.getAdminDashboard(adminId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      print('❌ Repository ServerException: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('❌ Repository UnexpectedFailure: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> getMemberDashboard(
      String memberId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('➡️ Repository: Fetching Member Dashboard for ID: "$memberId"');

      final models = await _remote.getMemberDashboard(memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      print('❌ Repository ServerException: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('❌ Repository UnexpectedFailure: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MemberBalanceEntity>>> getAllMemberBalances(
      String cycleId) async {
    try {
      // 👈 ডিবাগ প্রিন্ট অ্যাড করা হলো
      print('➡️ Repository: Fetching All Member Balances for Cycle: "$cycleId"');

      final models = await _remote.getAllMemberBalances(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      print('❌ Repository ServerException: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print('❌ Repository UnexpectedFailure: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}