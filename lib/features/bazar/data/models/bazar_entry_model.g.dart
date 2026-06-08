// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_entry_model.dart';

BazarEntryModel _$BazarEntryModelFromJson(Map<String, dynamic> json) =>
    BazarEntryModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String,
      memberId: json['member_id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      quantity: json['quantity'] as String?,
      bazarDate: json['bazar_date'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$BazarEntryModelToJson(BazarEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'member_id': instance.memberId,
      'description': instance.description,
      'amount': instance.amount,
      'quantity': instance.quantity,
      'bazar_date': instance.bazarDate,
      'created_at': instance.createdAt,
    };