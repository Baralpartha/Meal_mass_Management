// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_member_summary_model.dart';

CycleMemberSummaryModel _$CycleMemberSummaryModelFromJson(
    Map<String, dynamic> json) =>
    CycleMemberSummaryModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      memberId: json['member_id'] as String,
      openingBalance: (json['opening_balance'] as num).toDouble(),
      totalFullMeal: (json['total_full_meal'] as num).toInt(),
      totalHalfMeal: (json['total_half_meal'] as num).toInt(),
      totalMealUnit: (json['total_meal_unit'] as num).toDouble(),
      mealRate: (json['meal_rate'] as num).toDouble(),
      mealCost: (json['meal_cost'] as num).toDouble(),
      totalDeposit: (json['total_deposit'] as num).toDouble(),
      totalBazar: (json['total_bazar'] as num).toDouble(),
      currentBalance: (json['current_balance'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$CycleMemberSummaryModelToJson(
    CycleMemberSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'member_id': instance.memberId,
      'opening_balance': instance.openingBalance,
      'total_full_meal': instance.totalFullMeal,
      'total_half_meal': instance.totalHalfMeal,
      'total_meal_unit': instance.totalMealUnit,
      'meal_rate': instance.mealRate,
      'meal_cost': instance.mealCost,
      'total_deposit': instance.totalDeposit,
      'total_bazar': instance.totalBazar,
      'current_balance': instance.currentBalance,
      'status': instance.status,
      'created_at': instance.createdAt,
    };