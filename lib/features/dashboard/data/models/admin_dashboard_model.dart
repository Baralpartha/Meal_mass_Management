import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/admin_dashbord_entity.dart';

part 'admin_dashboard_model.g.dart';

@JsonSerializable()
class AdminDashboardModel {
  @JsonKey(name: 'total_members')
  final int totalMembers;
  @JsonKey(name: 'pending_members')
  final int pendingMembers;
  @JsonKey(name: 'approved_members')
  final int approvedMembers;
  @JsonKey(name: 'running_cycles')
  final int runningCycles;
  @JsonKey(name: 'total_meal_units')
  final double totalMealUnits;
  @JsonKey(name: 'total_bazar')
  final double totalBazar;
  @JsonKey(name: 'total_deposit')
  final double totalDeposit;
  @JsonKey(name: 'meal_rate')
  final double mealRate;

  const AdminDashboardModel({
    required this.totalMembers,
    required this.pendingMembers,
    required this.approvedMembers,
    required this.runningCycles,
    required this.totalMealUnits,
    required this.totalBazar,
    required this.totalDeposit,
    required this.mealRate,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminDashboardModelToJson(this);

  AdminDashboardEntity toEntity() => AdminDashboardEntity(
    totalMembers: totalMembers,
    pendingMembers: pendingMembers,
    approvedMembers: approvedMembers,
    runningCycles: runningCycles,
    totalMealUnits: totalMealUnits,
    totalBazar: totalBazar,
    totalDeposit: totalDeposit,
    mealRate: mealRate,
  );
}

@JsonSerializable()
class MemberBalanceModel {
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  @JsonKey(name: 'cycle_id')
  final String cycleId;
  @JsonKey(name: 'cycle_code')
  final String cycleCode;
  @JsonKey(name: 'cycle_status')
  final String cycleStatus;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  @JsonKey(name: 'total_full_meal')
  final int totalFullMeal;
  @JsonKey(name: 'total_half_meal')
  final int totalHalfMeal;
  @JsonKey(name: 'total_meal_unit')
  final double totalMealUnit;
  @JsonKey(name: 'total_bazar_all')
  final double totalBazarAll;
  @JsonKey(name: 'total_meal_all')
  final double totalMealAll;
  @JsonKey(name: 'meal_rate')
  final double mealRate;
  @JsonKey(name: 'total_deposit')
  final double totalDeposit;
  @JsonKey(name: 'meal_cost')
  final double mealCost;
  @JsonKey(name: 'current_balance')
  final double currentBalance;
  @JsonKey(name: 'balance_status')
  final String balanceStatus;

  const MemberBalanceModel({
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

  factory MemberBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$MemberBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberBalanceModelToJson(this);

  MemberBalanceEntity toEntity() => MemberBalanceEntity(
    memberId: memberId,
    fullName: fullName,
    mobileNumber: mobileNumber,
    cycleId: cycleId,
    cycleCode: cycleCode,
    cycleStatus: cycleStatus,
    openingBalance: openingBalance,
    totalFullMeal: totalFullMeal,
    totalHalfMeal: totalHalfMeal,
    totalMealUnit: totalMealUnit,
    totalBazarAll: totalBazarAll,
    totalMealAll: totalMealAll,
    mealRate: mealRate,
    totalDeposit: totalDeposit,
    mealCost: mealCost,
    currentBalance: currentBalance,
    balanceStatus: balanceStatus,
  );
}