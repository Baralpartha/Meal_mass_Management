import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/bazar_entry_entity.dart';

abstract class BazarRepository {
  Future<Either<Failure, List<BazarEntryEntity>>> getBazarByCycle(String cycleId);
  Future<Either<Failure, List<BazarEntryEntity>>> getBazarByMember(String memberId);
  Future<Either<Failure, String>> addBazar({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String description,
    required double amount,
    String? quantity,
    required String bazarDate,
  });
  Future<Either<Failure, void>> deleteBazar(String bazarId);
}