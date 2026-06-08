import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cycle_entity.dart';
import '../repositories/cycles_repository.dart';

@lazySingleton
class GetAllCyclesUseCase implements UseCaseNoParams<List<CycleEntity>> {
  final CyclesRepository _repository;
  GetAllCyclesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CycleEntity>>> call() =>
      _repository.getAllCycles();
}

@lazySingleton
class GetRunningCycleUseCase implements UseCaseNoParams<CycleEntity?> {
  final CyclesRepository _repository;
  GetRunningCycleUseCase(this._repository);

  @override
  Future<Either<Failure, CycleEntity?>> call() =>
      _repository.getRunningCycle();
}

class StartNewCycleParams extends Equatable {
  final String adminId;
  final String cycleCode;
  final String startDate;
  const StartNewCycleParams(
      {required this.adminId,
        required this.cycleCode,
        required this.startDate});
  @override
  List<Object?> get props => [adminId, cycleCode, startDate];
}

@lazySingleton
class StartNewCycleUseCase implements UseCase<String, StartNewCycleParams> {
  final CyclesRepository _repository;
  StartNewCycleUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(StartNewCycleParams params) =>
      _repository.startNewCycle(
          adminId: params.adminId,
          cycleCode: params.cycleCode,
          startDate: params.startDate);
}

class CloseCycleParams extends Equatable {
  final String adminId;
  final String cycleId;
  final String endDate;
  const CloseCycleParams(
      {required this.adminId, required this.cycleId, required this.endDate});
  @override
  List<Object?> get props => [adminId, cycleId, endDate];
}

@lazySingleton
class CloseCycleUseCase implements UseCase<String, CloseCycleParams> {
  final CyclesRepository _repository;
  CloseCycleUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(CloseCycleParams params) =>
      _repository.closeCycle(
          adminId: params.adminId,
          cycleId: params.cycleId,
          endDate: params.endDate);
}