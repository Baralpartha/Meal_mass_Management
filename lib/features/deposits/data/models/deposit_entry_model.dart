import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/deposit_entry_entity.dart';

part 'deposit_entry_model.g.dart';

@JsonSerializable()
class DepositEntryModel {
  final String id;
  @JsonKey(name: 'cycle_id')
  final String cycleId;
  @JsonKey(name: 'member_id')
  final String memberId;
  final double amount;
  @JsonKey(name: 'deposit_date')
  final String depositDate;
  final String? note;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const DepositEntryModel({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    required this.depositDate,
    this.note,
    required this.createdAt,
  });

  factory DepositEntryModel.fromJson(Map<String, dynamic> json) =>
      _$DepositEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DepositEntryModelToJson(this);

  DepositEntryEntity toEntity() => DepositEntryEntity(
    id: id,
    cycleId: cycleId,
    memberId: memberId,
    amount: amount,
    depositDate: DateTime.parse(depositDate),
    note: note,
    createdAt: DateTime.parse(createdAt),
  );
}