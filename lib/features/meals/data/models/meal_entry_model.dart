import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/meal_entry_entity.dart';

part 'meal_entry_model.g.dart';

@JsonSerializable()
class MealEntryModel {
  final String id;
  @JsonKey(name: 'cycle_id')
  final String cycleId;
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'meal_type')
  final String mealType;
  final int quantity;
  @JsonKey(name: 'meal_unit')
  final double? mealUnit;
  @JsonKey(name: 'meal_date')
  final String mealDate;
  final String? note;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const MealEntryModel({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.mealType,
    required this.quantity,
    this.mealUnit,
    required this.mealDate,
    this.note,
    required this.createdAt,
  });

  factory MealEntryModel.fromJson(Map<String, dynamic> json) =>
      _$MealEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealEntryModelToJson(this);

  MealEntryEntity toEntity() => MealEntryEntity(
    id: id,
    cycleId: cycleId,
    memberId: memberId,
    mealType: mealType == 'full' ? MealType.full : MealType.half,
    quantity: quantity,
    mealUnit: mealUnit ?? (mealType == 'full' ? quantity * 1.0 : quantity * 0.5),
    mealDate: DateTime.parse(mealDate),
    note: note,
    createdAt: DateTime.parse(createdAt),
  );
}