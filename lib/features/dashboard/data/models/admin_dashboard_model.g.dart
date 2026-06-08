// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_model.dart';

AdminDashboardModel _$AdminDashboardModelFromJson(Map<String, dynamic> json) =>
    AdminDashboardModel(
      totalMembers: (json['total_members'] as num).toInt(),
      pendingMembers: (json['pending_members'] as num).toInt(),
      approvedMembers: (json['approved_members'] as num).toInt(),
      runningCycles: (json['running_cycles'] as num).toInt(),
      totalMealUnits: (json['total_meal_units'] as num).toDouble(),
      totalBazar: (json['total_bazar'] as num).toDouble(),
      totalDeposit: (json['total_deposit'] as num).toDouble(),
      mealRate: (json['meal_rate'] as num).toDouble(),
    );

Map<String, dynamic> _$AdminDashboardModelToJson(
    AdminDashboardModel instance) =>
    <String, dynamic>{
      'total_members': instance.totalMembers,
      'pending_members': instance.pendingMembers,
      'approved_members': instance.approvedMembers,
      'running_cycles': instance.runningCycles,
      'total_meal_units': instance.totalMealUnits,
      'total_bazar': instance.totalBazar,
      'total_deposit': instance.totalDeposit,
      'meal_rate': instance.mealRate,
    };

MemberBalanceModel _$MemberBalanceModelFromJson(Map<String, dynamic> json) =>
    MemberBalanceModel(
      memberId: json['member_id'] as String,
      fullName: json['full_name'] as String,
      mobileNumber: json['mobile_number'] as String,
      cycleId: json['cycle_id'] as String,
      cycleCode: json['cycle_code'] as String,
      cycleStatus: json['cycle_status'] as String,
      openingBalance: (json['opening_balance'] as num).toDouble(),
      totalFullMeal: (json['total_full_meal'] as num).toInt(),
      totalHalfMeal: (json['total_half_meal'] as num).toInt(),
      totalMealUnit: (json['total_meal_unit'] as num).toDouble(),
      totalBazarAll: (json['total_bazar_all'] as num).toDouble(),
      totalMealAll: (json['total_meal_all'] as num).toDouble(),
      mealRate: (json['meal_rate'] as num).toDouble(),
      totalDeposit: (json['total_deposit'] as num).toDouble(),
      mealCost: (json['meal_cost'] as num).toDouble(),
      currentBalance: (json['current_balance'] as num).toDouble(),
      balanceStatus: json['balance_status'] as String,
    );

Map<String, dynamic> _$MemberBalanceModelToJson(MemberBalanceModel instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'full_name': instance.fullName,
      'mobile_number': instance.mobileNumber,
      'cycle_id': instance.cycleId,
      'cycle_code': instance.cycleCode,
      'cycle_status': instance.cycleStatus,
      'opening_balance': instance.openingBalance,
      'total_full_meal': instance.totalFullMeal,
      'total_half_meal': instance.totalHalfMeal,
      'total_meal_unit': instance.totalMealUnit,
      'total_bazar_all': instance.totalBazarAll,
      'total_meal_all': instance.totalMealAll,
      'meal_rate': instance.mealRate,
      'total_deposit': instance.totalDeposit,
      'meal_cost': instance.mealCost,
      'current_balance': instance.currentBalance,
      'balance_status': instance.balanceStatus,
    };