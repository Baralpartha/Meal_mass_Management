import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/deposit_entry_entity.dart';
import '../repositories/deposits_repository.dart';

class GetDepositsByCycleParams extends Equatable {
  final String cycleId;
  const GetDepositsByCycleParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetDepositsByCycleUseCase
    implements UseCase<List<DepositEntryEntity>, GetDepositsByCycleParams> {
  final DepositsRepository _repository;
  GetDepositsByCycleUseCase(this._repository);
  @override
  Future<Either<Failure, List<DepositEntryEntity>>> call(
          GetDepositsByCycleParams params) =>
      _repository.getDepositsByCycle(params.cycleId);
}

class GetDepositsByMemberParams extends Equatable {
  final String memberId;
  const GetDepositsByMemberParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetDepositsByMemberUseCase
    implements UseCase<List<DepositEntryEntity>, GetDepositsByMemberParams> {
  final DepositsRepository _repository;
  GetDepositsByMemberUseCase(this._repository);
  @override
  Future<Either<Failure, List<DepositEntryEntity>>> call(
          GetDepositsByMemberParams params) =>
      _repository.getDepositsByMember(params.memberId);
}

class AddDepositParams extends Equatable {
  final String adminId;
  final String cycleId;
  final String memberId;
  final double amount;
  final String depositDate;
  final String? note;
  const AddDepositParams({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    required this.depositDate,
    this.note,
  });
  @override
  List<Object?> get props => [cycleId, memberId, amount, depositDate];
}

@lazySingleton
class AddDepositUseCase implements UseCase<String, AddDepositParams> {
  final DepositsRepository _repository;
  AddDepositUseCase(this._repository);
  @override
  Future<Either<Failure, String>> call(AddDepositParams params) =>
      _repository.addDeposit(
        adminId: params.adminId,
        cycleId: params.cycleId,
        memberId: params.memberId,
        amount: params.amount,
        depositDate: params.depositDate,
        note: params.note,
      );
}

class DeleteDepositParams extends Equatable {
  final String depositId;
  const DeleteDepositParams(this.depositId);
  @override
  List<Object?> get props => [depositId];
}

@lazySingleton
class DeleteDepositUseCase implements UseCase<void, DeleteDepositParams> {
  final DepositsRepository _repository;
  DeleteDepositUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(DeleteDepositParams params) =>
      _repository.deleteDeposit(params.depositId);
}
