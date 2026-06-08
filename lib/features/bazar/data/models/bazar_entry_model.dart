import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/bazar_entry_entity.dart';

part 'bazar_entry_model.g.dart';

@JsonSerializable()
class BazarEntryModel {
  final String id;
  @JsonKey(name: 'cycle_id')
  final String cycleId;
  @JsonKey(name: 'member_id')
  final String memberId;
  final String description;
  final double amount;
  final String? quantity;
  @JsonKey(name: 'bazar_date')
  final String bazarDate;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const BazarEntryModel({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.description,
    required this.amount,
    this.quantity,
    required this.bazarDate,
    required this.createdAt,
  });

  factory BazarEntryModel.fromJson(Map<String, dynamic> json) =>
      _$BazarEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$BazarEntryModelToJson(this);

  BazarEntryEntity toEntity() => BazarEntryEntity(
    id: id,
    cycleId: cycleId,
    memberId: memberId,
    description: description,
    amount: amount,
    quantity: quantity,
    bazarDate: DateTime.parse(bazarDate),
    createdAt: DateTime.parse(createdAt),
  );
}