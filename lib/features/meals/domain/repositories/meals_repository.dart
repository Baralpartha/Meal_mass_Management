import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal_entry_entity.dart';

abstract class MealsRepository {
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByCycle(String cycleId);
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByMember(String memberId);
  Future<Either<Failure, List<MealEntryEntity>>> getMealsByCycleAndMember({
    required String cycleId,
    required String memberId,
  });
  Future<Either<Failure, String>> addMeal({
    required String adminId,
    required String cycleId,
    required String memberId,
    required String mealType,
    required int quantity,
    required String mealDate,
    String? note,
  });
  Future<Either<Failure, void>> deleteMeal(String mealId);
}