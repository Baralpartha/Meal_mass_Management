import 'package:equatable/equatable.dart';

class AdminDashboardEntity extends Equatable {
  final int totalMembers;
  final int pendingMembers;
  final int approvedMembers;
  final int runningCycles;
  final double totalMealUnits;
  final double totalBazar;
  final double totalDeposit;
  final double mealRate;

  const AdminDashboardEntity({
    required this.totalMembers,
    required this.pendingMembers,
    required this.approvedMembers,
    required this.runningCycles,
    required this.totalMealUnits,
    required this.totalBazar,
    required this.totalDeposit,
    required this.mealRate,
  });

  @override
  List<Object?> get props => [
    totalMembers, pendingMembers, approvedMembers, runningCycles,
    totalMealUnits, totalBazar, totalDeposit, mealRate,
  ];
}

class MemberBalanceEntity extends Equatable {
  final String memberId;
  final String fullName;
  final String mobileNumber;
  final String cycleId;
  final String cycleCode;
  final String cycleStatus;
  final double openingBalance;
  final int totalFullMeal;
  final int totalHalfMeal;
  final double totalMealUnit;
  final double totalBazarAll;
  final double totalMealAll;
  final double mealRate;
  final double totalDeposit;
  final double mealCost;
  final double currentBalance;
  final String balanceStatus;

  const MemberBalanceEntity({
    required this.memberId,
    required this.fullName,
    required this.mobileNumber,
    required this.cycleId,
    required this.cycleCode,
    required this.cycleStatus,
    required this.openingBalance,
    required this.totalFullMeal,
    required this.totalHalfMeal,
    required this.totalMealUnit,
    required this.totalBazarAll,
    required this.totalMealAll,
    required this.mealRate,
    required this.totalDeposit,
    required this.mealCost,
    required this.currentBalance,
    required this.balanceStatus,
  });

  bool get isPositive => currentBalance > 0;
  bool get isNegative => currentBalance < 0;

  @override
  List<Object?> get props => [
    memberId, fullName, mobileNumber, cycleId, cycleCode, cycleStatus,
    openingBalance, totalFullMeal, totalHalfMeal, totalMealUnit,
    totalBazarAll, totalMealAll, mealRate, totalDeposit, mealCost,
    currentBalance, balanceStatus,
  ];
}