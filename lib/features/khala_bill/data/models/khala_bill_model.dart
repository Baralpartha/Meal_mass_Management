import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/khala_bill_entity.dart';

part 'khala_bill_model.g.dart';

@JsonSerializable()
class KhalaBillModel {
  final String id;
  @JsonKey(name: 'cycle_id')
  final String? cycleId;
  @JsonKey(name: 'member_id')
  final String memberId;
  final double amount;
  final String? note;
  @JsonKey(name: 'bill_date')
  final String billDate;
  @JsonKey(name: 'created_at')
  final String createdAt;

  const KhalaBillModel({
    required this.id,
    this.cycleId,
    required this.memberId,
    required this.amount,
    this.note,
    required this.billDate,
    required this.createdAt,
  });

  factory KhalaBillModel.fromJson(Map<String, dynamic> json) =>
      _$KhalaBillModelFromJson(json);

  Map<String, dynamic> toJson() => _$KhalaBillModelToJson(this);

  KhalaBillEntity toEntity() => KhalaBillEntity(
    id: id,
    cycleId: cycleId,
    memberId: memberId,
    amount: amount,
    note: note,
    billDate: DateTime.parse(billDate),
    createdAt: DateTime.parse(createdAt),
  );
}