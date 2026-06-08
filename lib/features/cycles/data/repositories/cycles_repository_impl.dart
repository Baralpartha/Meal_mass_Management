import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/cycle_entity.dart';
import '../../domain/repositories/cycles_repository.dart';
import '../datasources/cycles_remote_datasource.dart';

@LazySingleton(as: CyclesRepository)
class CyclesRepositoryImpl implements CyclesRepository {
  final CyclesRemoteDataSource _remote;

  CyclesRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<CycleEntity>>> getAllCycles() async {
    try {
      final models = await _remote.getAllCycles();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CycleEntity?>> getRunningCycle() async {
    try {
      final model = await _remote.getRunningCycle();
      return Right(model?.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> startNewCycle({
    required String adminId,
    required String cycleCode,
    required String startDate,
  }) async {
    try {
      final result = await _remote.startNewCycle(
          adminId: adminId, cycleCode: cycleCode, startDate: startDate);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> closeCycle({
    required String adminId,
    required String cycleId,
    required String endDate,
  }) async {
    try {
      final result = await _remote.closeCycle(
          adminId: adminId, cycleId: cycleId, endDate: endDate);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}