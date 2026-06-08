import 'package:equatable/equatable.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();
  @override
  List<Object?> get props => [];
}

class MealsLoadByCycle extends MealsEvent {
  final String cycleId;
  const MealsLoadByCycle(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class MealsLoadByMember extends MealsEvent {
  final String memberId;
  const MealsLoadByMember(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

class MealsAdd extends MealsEvent {
  final String adminId;
  final String cycleId;
  final String memberId;
  final String mealType;
  final int quantity;
  final String mealDate;
  final String? note;
  const MealsAdd({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.mealType,
    required this.quantity,
    required this.mealDate,
    this.note,
  });
  @override
  List<Object?> get props => [cycleId, memberId, mealType, quantity, mealDate];
}

class MealsDelete extends MealsEvent {
  final String mealId;
  final String cycleId;
  const MealsDelete({required this.mealId, required this.cycleId});
  @override
  List<Object?> get props => [mealId];
}