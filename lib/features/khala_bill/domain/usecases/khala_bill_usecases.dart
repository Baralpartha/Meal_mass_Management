import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/khala_bill_entity.dart';
import '../repositories/khala_bill_repository.dart';

class GetKhalaBillsByCycleParams extends Equatable {
  final String cycleId;
  const GetKhalaBillsByCycleParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetKhalaBillsByCycleUseCase
    implements UseCase<List<KhalaBillEntity>, GetKhalaBillsByCycleParams> {
  final KhalaBillRepository _repository;
  GetKhalaBillsByCycleUseCase(this._repository);
  @override
  Future<Either<Failure, List<KhalaBillEntity>>> call(
          GetKhalaBillsByCycleParams params) =>
      _repository.getKhalaBillsByCycle(params.cycleId);
}

class GetKhalaBillsByMemberParams extends Equatable {
  final String memberId;
  const GetKhalaBillsByMemberParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetKhalaBillsByMemberUseCase
    implements UseCase<List<KhalaBillEntity>, GetKhalaBillsByMemberParams> {
  final KhalaBillRepository _repository;
  GetKhalaBillsByMemberUseCase(this._repository);
  @override
  Future<Either<Failure, List<KhalaBillEntity>>> call(
          GetKhalaBillsByMemberParams params) =>
      _repository.getKhalaBillsByMember(params.memberId);
}

class AddKhalaBillParams extends Equatable {
  final String adminId;
  final String cycleId;
  final String memberId;
  final double amount;
  final String? note;
  final String billDate;
  const AddKhalaBillParams({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    this.note,
    required this.billDate,
  });
  @override
  List<Object?> get props => [cycleId, memberId, amount, billDate];
}

@lazySingleton
class AddKhalaBillUseCase implements UseCase<String, AddKhalaBillParams> {
  final KhalaBillRepository _repository;
  AddKhalaBillUseCase(this._repository);
  @override
  Future<Either<Failure, String>> call(AddKhalaBillParams params) =>
      _repository.addKhalaBill(
        adminId: params.adminId,
        cycleId: params.cycleId,
        memberId: params.memberId,
        amount: params.amount,
        note: params.note,
        billDate: params.billDate,
      );
}

class DeleteKhalaBillParams extends Equatable {
  final String billId;
  const DeleteKhalaBillParams(this.billId);
  @override
  List<Object?> get props => [billId];
}

@lazySingleton
class DeleteKhalaBillUseCase implements UseCase<void, DeleteKhalaBillParams> {
  final KhalaBillRepository _repository;
  DeleteKhalaBillUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(DeleteKhalaBillParams params) =>
      _repository.deleteKhalaBill(params.billId);
}
