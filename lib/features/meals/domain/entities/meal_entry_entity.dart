import 'package:equatable/equatable.dart';

enum MealType { full, half }

extension MealTypeExtension on MealType {
  String get value => name;
  double get unitMultiplier => this == MealType.full ? 1.0 : 0.5;
  String get displayName => this == MealType.full ? 'Full Meal' : 'Half Meal';
}

class MealEntryEntity extends Equatable {
  final String id;
  final String cycleId;
  final String memberId;
  final MealType mealType;
  final int quantity;
  final double mealUnit;
  final DateTime mealDate;
  final String? note;
  final DateTime createdAt;

  const MealEntryEntity({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.mealType,
    required this.quantity,
    required this.mealUnit,
    required this.mealDate,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, cycleId, memberId, mealType, quantity,
    mealUnit, mealDate, note, createdAt,
  ];
}