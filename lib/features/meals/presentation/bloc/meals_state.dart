import 'package:equatable/equatable.dart';
import '../../domain/entities/meal_entry_entity.dart';

abstract class MealsState extends Equatable {
  const MealsState();
  @override
  List<Object?> get props => [];
}

class MealsInitial extends MealsState {
  const MealsInitial();
}

class MealsLoading extends MealsState {
  const MealsLoading();
}

class MealsLoaded extends MealsState {
  final List<MealEntryEntity> meals;
  const MealsLoaded(this.meals);
  @override
  List<Object?> get props => [meals];
}

class MealsActionSuccess extends MealsState {
  final String message;
  final List<MealEntryEntity> meals;
  const MealsActionSuccess({required this.message, required this.meals});
  @override
  List<Object?> get props => [message, meals];
}

class MealsError extends MealsState {
  final String message;
  const MealsError(this.message);
  @override
  List<Object?> get props => [message];
}