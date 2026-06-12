import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../dashboard/domain/entities/admin_dashbord_entity.dart';
import '../entities/cycle_member_summary_entity.dart';

abstract class ReportsRepository {
  Future<Either<Failure, List<CycleMemberSummaryEntity>>> getCycleSummaries(
      String cycleId);
  Future<Either<Failure, List<MemberBalanceEntity>>> getMemberBalanceView(
      String cycleId);
  Future<Either<Failure, List<MemberBalanceEntity>>> getAllMemberBalances();
}
