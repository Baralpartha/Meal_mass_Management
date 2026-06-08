import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bazar_entry_entity.dart';
import '../repositories/bazar_repository.dart';

class GetBazarByCycleParams extends Equatable {
  final String cycleId;
  const GetBazarByCycleParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetBazarByCycleUseCase
    implements UseCase<List<BazarEntryEntity>, GetBazarByCycleParams> {
  final BazarRepository _repository;
  GetBazarByCycleUseCase(this._repository);
  @override
  Future<Either<Failure, List<BazarEntryEntity>>> call(
      GetBazarByCycleParams params) =>
      _repository.getBazarByCycle(params.cycleId);
}

class GetBazarByMemberParams extends Equatable {
  final String memberId;
  const GetBazarByMemberParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetBazarByMemberUseCase
    implements UseCase<List<BazarEntryEntity>, GetBazarByMemberParams> {
  final BazarRepository _repository;
  GetBazarByMemberUseCase(this._repository);
  @override
  Future<Either<Failure, List<BazarEntryEntity>>> call(
      GetBazarByMemberParams params) =>
      _repository.getBazarByMember(params.memberId);
}

class AddBazarParams extends Equatable {
  final String adminId;
  final String cycleId;
  final String memberId;
  final String description;
  final double amount;
  final String? quantity;
  final String bazarDate;
  const AddBazarParams({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.description,
    required this.amount,
    this.quantity,
    required this.bazarDate,
  });
  @override
  List<Object?> get props => [cycleId, memberId, description, amount, bazarDate];
}

@lazySingleton
class AddBazarUseCase implements UseCase<String, AddBazarParams> {
  final BazarRepository _repository;
  AddBazarUseCase(this._repository);
  @override
  Future<Either<Failure, String>> call(AddBazarParams params) =>
      _repository.addBazar(
        adminId: params.adminId,
        cycleId: params.cycleId,
        memberId: params.memberId,
        description: params.description,
        amount: params.amount,
        quantity: params.quantity,
        bazarDate: params.bazarDate,
      );
}

class DeleteBazarParams extends Equatable {
  final String bazarId;
  const DeleteBazarParams(this.bazarId);
  @override
  List<Object?> get props => [bazarId];
}

@lazySingleton
class DeleteBazarUseCase implements UseCase<void, DeleteBazarParams> {
  final BazarRepository _repository;
  DeleteBazarUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(DeleteBazarParams params) =>
      _repository.deleteBazar(params.bazarId);
}