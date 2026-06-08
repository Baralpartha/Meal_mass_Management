import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/meals_usecases.dart';
import 'meals_event.dart';
import 'meals_state.dart';

@injectable
class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final GetMealsByCycleUseCase _getMealsByCycle;
  final GetMealsByMemberUseCase _getMealsByMember;
  final AddMealUseCase _addMeal;
  final DeleteMealUseCase _deleteMeal;

  MealsBloc(
      this._getMealsByCycle,
      this._getMealsByMember,
      this._addMeal,
      this._deleteMeal,
      ) : super(const MealsInitial()) {
    on<MealsLoadByCycle>(_onLoadByCycle);
    on<MealsLoadByMember>(_onLoadByMember);
    on<MealsAdd>(_onAdd);
    on<MealsDelete>(_onDelete);
  }

  Future<void> _onLoadByCycle(
      MealsLoadByCycle event, Emitter<MealsState> emit) async {
    emit(const MealsLoading());
    final result = await _getMealsByCycle(GetMealsByCycleParams(event.cycleId));
    result.fold(
          (f) => emit(MealsError(f.message)),
          (meals) => emit(MealsLoaded(meals)),
    );
  }

  Future<void> _onLoadByMember(
      MealsLoadByMember event, Emitter<MealsState> emit) async {
    emit(const MealsLoading());
    final result =
    await _getMealsByMember(GetMealsByMemberParams(event.memberId));
    result.fold(
          (f) => emit(MealsError(f.message)),
          (meals) => emit(MealsLoaded(meals)),
    );
  }

  Future<void> _onAdd(MealsAdd event, Emitter<MealsState> emit) async {
    emit(const MealsLoading());
    final result = await _addMeal(AddMealParams(
      adminId: event.adminId,
      cycleId: event.cycleId,
      memberId: event.memberId,
      mealType: event.mealType,
      quantity: event.quantity,
      mealDate: event.mealDate,
      note: event.note,
    ));
    await result.fold(
          (f) async => emit(MealsError(f.message)),
          (_) async {
        final refreshed =
        await _getMealsByCycle(GetMealsByCycleParams(event.cycleId));
        refreshed.fold(
              (f) => emit(MealsError(f.message)),
              (meals) => emit(
              MealsActionSuccess(message: 'Meal added successfully', meals: meals)),
        );
      },
    );
  }

  Future<void> _onDelete(MealsDelete event, Emitter<MealsState> emit) async {
    emit(const MealsLoading());
    final result = await _deleteMeal(DeleteMealParams(event.mealId));
    await result.fold(
          (f) async => emit(MealsError(f.message)),
          (_) async {
        final refreshed =
        await _getMealsByCycle(GetMealsByCycleParams(event.cycleId));
        refreshed.fold(
              (f) => emit(MealsError(f.message)),
              (meals) =>
              emit(MealsActionSuccess(message: 'Meal deleted', meals: meals)),
        );
      },
    );
  }
}