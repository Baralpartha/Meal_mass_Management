import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/bazar_entry_entity.dart';
import '../../domain/repositories/bazar_repository.dart';
import '../datasources/bazar_remote_datasource.dart';

@LazySingleton(as: BazarRepository)
class BazarRepositoryImpl implements BazarRepository {
  final BazarRemoteDataSource _remote;
  BazarRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<BazarEntryEntity>>> getBazarByCycle(
      String cycleId) async {
    try {
      final models = await _remote.getBazarByCycle(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BazarEntryEntity>>> getBazarByMember(
      String memberId) async {
    try {
      final models = await _remote.getBazarByMember(memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addBazar({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String description,
    required double amount,
    String? quantity,
    required String bazarDate,
  }) async {
    try {
      final result = await _remote.addBazar(
        adminId: adminId,
        cycleId: cycleId,
        memberId: memberId,
        description: description,
        amount: amount,
        quantity: quantity,
        bazarDate: bazarDate,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBazar(String bazarId) async {
    try {
      await _remote.deleteBazar(bazarId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}