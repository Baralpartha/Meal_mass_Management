import 'package:equatable/equatable.dart';

enum CycleStatus { running, closed }

extension CycleStatusExtension on CycleStatus {
  String get value => name;
  bool get isRunning => this == CycleStatus.running;
}

class CycleEntity extends Equatable {
  final String id;
  final String cycleCode;
  final DateTime startDate;
  final DateTime? endDate;
  final CycleStatus status;
  final double totalMealUnits;
  final double totalBazar;
  final double totalDeposit;
  final double mealRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CycleEntity({
    required this.id,
    required this.cycleCode,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.totalMealUnits,
    required this.totalBazar,
    required this.totalDeposit,
    required this.mealRate,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRunning => status == CycleStatus.running;

  @override
  List<Object?> get props => [
    id, cycleCode, startDate, endDate, status,
    totalMealUnits, totalBazar, totalDeposit, mealRate,
    createdAt, updatedAt,
  ];
}