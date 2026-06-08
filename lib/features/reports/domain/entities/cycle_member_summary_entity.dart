import 'package:equatable/equatable.dart';

enum BalanceStatus { advance, due, settled }

extension BalanceStatusExtension on BalanceStatus {
  String get value => name;
  String get displayName {
    switch (this) {
      case BalanceStatus.advance:
        return 'Advance';
      case BalanceStatus.due:
        return 'Due';
      case BalanceStatus.settled:
        return 'Settled';
    }
  }
}

class CycleMemberSummaryEntity extends Equatable {
  final String id;
  final String cycleId;
  final String memberId;
  final double openingBalance;
  final int totalFullMeal;
  final int totalHalfMeal;
  final double totalMealUnit;
  final double mealRate;
  final double mealCost;
  final double totalDeposit;
  final double totalBazar;
  final double currentBalance;
  final BalanceStatus status;
  final DateTime createdAt;

  const CycleMemberSummaryEntity({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.openingBalance,
    required this.totalFullMeal,
    required this.totalHalfMeal,
    required this.totalMealUnit,
    required this.mealRate,
    required this.mealCost,
    required this.totalDeposit,
    required this.totalBazar,
    required this.currentBalance,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, cycleId, memberId, openingBalance, totalFullMeal,
    totalHalfMeal, totalMealUnit, mealRate, mealCost,
    totalDeposit, totalBazar, currentBalance, status, createdAt,
  ];
}