// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleModel _$CycleModelFromJson(Map<String, dynamic> json) => CycleModel(
  id: json['id'] as String,
  cycleCode: json['cycle_code'] as String,
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String?,
  status: json['status'] as String,
  totalMealUnits: (json['total_meal_units'] as num?)?.toDouble(),
  totalBazar: (json['total_bazar'] as num?)?.toDouble(),
  totalDeposit: (json['total_deposit'] as num?)?.toDouble(),
  mealRate: (json['meal_rate'] as num?)?.toDouble(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$CycleModelToJson(CycleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_code': instance.cycleCode,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'status': instance.status,
      'total_meal_units': instance.totalMealUnits,
      'total_bazar': instance.totalBazar,
      'total_deposit': instance.totalDeposit,
      'meal_rate': instance.mealRate,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };