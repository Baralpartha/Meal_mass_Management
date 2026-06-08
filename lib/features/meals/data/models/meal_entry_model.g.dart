// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_entry_model.dart';

MealEntryModel _$MealEntryModelFromJson(Map<String, dynamic> json) =>
    MealEntryModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      memberId: json['member_id'] as String,
      mealType: json['meal_type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      mealUnit: (json['meal_unit'] as num?)?.toDouble(),
      mealDate: json['meal_date'] as String,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$MealEntryModelToJson(MealEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'member_id': instance.memberId,
      'meal_type': instance.mealType,
      'quantity': instance.quantity,
      'meal_unit': instance.mealUnit,
      'meal_date': instance.mealDate,
      'note': instance.note,
      'created_at': instance.createdAt,
    };