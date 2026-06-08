import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../domain/entities/meal_entry_entity.dart';
import '../../domain/repositories/meals_repository.dart';
import '../datasources/meals_remote_datasource.dart';

@LazySingleton(as: MealsRepository)
class MealsRepositoryImpl implements MealsRepository {
  final MealsRemoteDataSource _remote;
  MealsRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByCycle(
      String cycleId) async {
    try {
      final models = await _remote.getMealsByCycle(cycleId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByMember(
      String memberId) async {
    try {
      final models = await _remote.getMealsByMember(memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByCycleAndMember({
    required String cycleId,
    required String memberId,
  }) async {
    try {
      final models = await _remote.getMealsByCycleAndMember(
          cycleId: cycleId, memberId: memberId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addMeal({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String mealType,
    required int quantity,
    required String mealDate,
    String? note,
  }) async {
    try {
      final result = await _remote.addMeal(
        adminId: adminId,
        cycleId: cycleId,
        memberId: memberId,
        mealType: mealType,
        quantity: quantity,
        mealDate: mealDate,
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
  Future<Either<Failure, void>> deleteMeal(String mealId) async {
    try {
      await _remote.deleteMeal(mealId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}