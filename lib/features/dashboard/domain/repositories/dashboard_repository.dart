import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin_dashbord_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, AdminDashboardEntity>> getAdminDashboard(
      String adminId);
  Future<Either<Failure, List<MemberBalanceEntity>>> getMemberDashboard(
      String memberId);
  Future<Either<Failure, List<MemberBalanceEntity>>> getAllMemberBalances(
      String cycleId);
}