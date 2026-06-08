import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cycle_entity.dart';

abstract class CyclesRepository {
  Future<Either<Failure, List<CycleEntity>>> getAllCycles();
  Future<Either<Failure, CycleEntity?>> getRunningCycle();
  Future<Either<Failure, String>> startNewCycle({
    required String adminId,
    required String cycleCode,
    required String startDate,
  });
  Future<Either<Failure, String>> closeCycle({
    required String adminId,
    required String cycleId,
    required String endDate,
  });
}