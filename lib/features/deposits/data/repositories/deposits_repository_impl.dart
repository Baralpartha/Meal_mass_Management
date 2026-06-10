import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/deposit_entry_entity.dart';
import '../../domain/repositories/deposits_repository.dart';
import '../datasources/deposits_remote_datasource.dart';

@LazySingleton(as: DepositsRepository)
class DepositsRepositoryImpl implements DepositsRepository {
  final DepositsRemoteDataSource _remote;
  DepositsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<DepositEntryEntity>>> getDepositsByCycle(
      String cycleId) async {
    try {
      final models = await _remote.getDepositsByCycle(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DepositEntryEntity>>> getDepositsByMember(
      String memberId) async {
    try {
      final models = await _remote.getDepositsByMember(memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addDeposit({
    required String adminId,
    required String cycleId,
    required String memberId,
    required double amount,
    required String depositDate,
    String? note,
  }) async {
    try {
      final result = await _remote.addDeposit(
        adminId: adminId,
        cycleId: cycleId,
        memberId: memberId,
        amount: amount,
        depositDate: depositDate,
        note: note,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDeposit(String depositId) async {
    try {
      await _remote.deleteDeposit(depositId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
