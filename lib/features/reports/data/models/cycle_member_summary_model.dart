import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cycle_member_summary_entity.dart';

part 'cycle_member_summary_model.g.dart';

@JsonSerializable()
class CycleMemberSummaryModel {
  final String id;
  @JsonKey(name: 'cycle_id')
  final String cycleId;
  @JsonKey(name: 'member_id')
  final String memberId;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  @JsonKey(name: 'total_full_meal')
  final int totalFullMeal;
  @JsonKey(name: 'total_half_meal')
  final int totalHalfMeal;
  @JsonKey(name: 'total_meal_unit')
  final double totalMealUnit;
  @JsonKey(name: 'meal_rate')
  final double mealRate;
  @JsonKey(name: 'meal_cost')
  final double mealCost;
  @JsonKey(name: 'total_deposit')
  final double totalDeposit;
  @JsonKey(name: 'total_bazar')
  final double totalBazar;
  @JsonKey(name: 'current_balance')
  final double currentBalance;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const CycleMemberSummaryModel({
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

  factory CycleMemberSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CycleMemberSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CycleMemberSummaryModelToJson(this);

  CycleMemberSummaryEntity toEntity() => CycleMemberSummaryEntity(
    id: id,
    cycleId: cycleId,
    memberId: memberId,
    openingBalance: openingBalance,
    totalFullMeal: totalFullMeal,
    totalHalfMeal: totalHalfMeal,
    totalMealUnit: totalMealUnit,
    mealRate: mealRate,
    mealCost: mealCost,
    totalDeposit: totalDeposit,
    totalBazar: totalBazar,
    currentBalance: currentBalance,
    status: _parseStatus(status),
    createdAt: DateTime.parse(createdAt),
  );

  static BalanceStatus _parseStatus(String s) {
    switch (s) {
      case 'advance':
        return BalanceStatus.advance;
      case 'due':
        return BalanceStatus.due;
      default:
        return BalanceStatus.settled;
    }
  }
}