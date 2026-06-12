import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/khala_bill_entity.dart';
import '../../domain/repositories/khala_bill_repository.dart';
import '../datasources/khala_bill_remote_datasource.dart';

@LazySingleton(as: KhalaBillRepository)
class KhalaBillRepositoryImpl implements KhalaBillRepository {
  final KhalaBillRemoteDataSource _remote;
  KhalaBillRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<KhalaBillEntity>>> getKhalaBillsByCycle(
      String cycleId) async {
    try {
      final models = await _remote.getKhalaBillsByCycle(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<KhalaBillEntity>>> getKhalaBillsByMember(
      String memberId) async {
    try {
      final models = await _remote.getKhalaBillsByMember(memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addKhalaBill({
    required String adminId,
    required String cycleId,
    required String memberId,
    required double amount,
    String? note,
    required String billDate,
  }) async {
    try {
      final result = await _remote.addKhalaBill(
        adminId: adminId,
        cycleId: cycleId,
        memberId: memberId,
        amount: amount,
        note: note,
        billDate: billDate,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteKhalaBill(String billId) async {
    try {
      await _remote.deleteKhalaBill(billId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
