import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/deposit_entry_entity.dart';

abstract class DepositsRepository {
  Future<Either<Failure, List<DepositEntryEntity>>> getDepositsByCycle(String cycleId);
  Future<Either<Failure, List<DepositEntryEntity>>> getDepositsByMember(String memberId);
  Future<Either<Failure, String>> addDeposit({
    required String adminId,
    required String cycleId,
    required String memberId,
    required double amount,
    required String depositDate,
    String? note,
  });
  Future<Either<Failure, void>> deleteDeposit(String depositId);
}
