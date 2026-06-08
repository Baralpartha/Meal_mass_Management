import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/meal_entry_entity.dart';
import '../repositories/meals_repository.dart';

class GetMealsByCycleParams extends Equatable {
  final String cycleId;
  const GetMealsByCycleParams(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

@lazySingleton
class GetMealsByCycleUseCase
    implements UseCase<List<MealEntryEntity>, GetMealsByCycleParams> {
  final MealsRepository _repository;
  GetMealsByCycleUseCase(this._repository);
  @override
  Future<Either<Failure, List<MealEntryEntity>>> call(
      GetMealsByCycleParams params) =>
      _repository.getMealsByCycle(params.cycleId);
}

class GetMealsByMemberParams extends Equatable {
  final String memberId;
  const GetMealsByMemberParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetMealsByMemberUseCase
    implements UseCase<List<MealEntryEntity>, GetMealsByMemberParams> {
  final MealsRepository _repository;
  GetMealsByMemberUseCase(this._repository);
  @override
  Future<Either<Failure, List<MealEntryEntity>>> call(
      GetMealsByMemberParams params) =>
      _repository.getMealsByMember(params.memberId);
}

class AddMealParams extends Equatable {
  final String adminId;
  final String cycleId;
  final String memberId;
  final String mealType;
  final int quantity;
  final String mealDate;
  final String? note;
  const AddMealParams({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.mealType,
    required this.quantity,
    required this.mealDate,
    this.note,
  });
  @override
  List<Object?> get props =>
      [adminId, cycleId, memberId, mealType, quantity, mealDate];
}

@lazySingleton
class AddMealUseCase implements UseCase<String, AddMealParams> {
  final MealsRepository _repository;
  AddMealUseCase(this._repository);
  @override
  Future<Either<Failure, String>> call(AddMealParams params) =>
      _repository.addMeal(
        adminId: params.adminId,
        cycleId: params.cycleId,
        memberId: params.memberId,
        mealType: params.mealType,
        quantity: params.quantity,
        mealDate: params.mealDate,
        note: params.note,
      );
}

class DeleteMealParams extends Equatable {
  final String mealId;
  const DeleteMealParams(this.mealId);
  @override
  List<Object?> get props => [mealId];
}

@lazySingleton
class DeleteMealUseCase implements UseCase<void, DeleteMealParams> {
  final MealsRepository _repository;
  DeleteMealUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(DeleteMealParams params) =>
      _repository.deleteMeal(params.mealId);
}