import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/khala_bill_entity.dart';

abstract class KhalaBillRepository {
  Future<Either<Failure, List<KhalaBillEntity>>> getKhalaBillsByMember(String memberId);
  Future<Either<Failure, List<KhalaBillEntity>>> getKhalaBillsByCycle(String cycleId);
  Future<Either<Failure, String>> addKhalaBill({
    required String adminId, required String cycleId, required String memberId,
    required double amount, String? note, required String billDate,
  });
  Future<Either<Failure, void>> deleteKhalaBill(String billId);
}
