import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cycle_entity.dart';

part 'cycle_model.g.dart';

@JsonSerializable()
class CycleModel {
  final String id;

  @JsonKey(name: 'cycle_code')
  final String cycleCode;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  final String status;

  @JsonKey(name: 'total_meal_units')
  final double? totalMealUnits;

  @JsonKey(name: 'total_bazar')
  final double? totalBazar;

  @JsonKey(name: 'total_deposit')
  final double? totalDeposit;

  @JsonKey(name: 'meal_rate')
  final double? mealRate;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const CycleModel({
    required this.id,
    required this.cycleCode,
    required this.startDate,
    this.endDate,
    required this.status,
    this.totalMealUnits,
    this.totalBazar,
    this.totalDeposit,
    this.mealRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CycleModel.fromJson(Map<String, dynamic> json) =>
      _$CycleModelFromJson(json);

  Map<String, dynamic> toJson() => _$CycleModelToJson(this);

  CycleEntity toEntity() {
    return CycleEntity(
      id: id,
      cycleCode: cycleCode,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      status:
      status == 'running'
          ? CycleStatus.running
          : CycleStatus.closed,
      totalMealUnits: totalMealUnits ?? 0,
      totalBazar: totalBazar ?? 0,
      totalDeposit: totalDeposit ?? 0,
      mealRate: mealRate ?? 0,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'cycle_code': cycleCode,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'total_meal_units': totalMealUnits,
      'total_bazar': totalBazar,
      'total_deposit': totalDeposit,
      'meal_rate': mealRate,
    };
  }
}