// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_entry_model.dart';

DepositEntryModel _$DepositEntryModelFromJson(Map<String, dynamic> json) =>
    DepositEntryModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      memberId: json['member_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      depositDate: json['deposit_date'] as String,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$DepositEntryModelToJson(DepositEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'member_id': instance.memberId,
      'amount': instance.amount,
      'deposit_date': instance.depositDate,
      'note': instance.note,
      'created_at': instance.createdAt,
    };