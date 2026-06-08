// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khala_bill_model.dart';

KhalaBillModel _$KhalaBillModelFromJson(Map<String, dynamic> json) =>
    KhalaBillModel(
      id: json['id'] as String,
      cycleId: json['cycle_id'] as String?,
      memberId: json['member_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String?,
      billDate: json['bill_date'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$KhalaBillModelToJson(KhalaBillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'member_id': instance.memberId,
      'amount': instance.amount,
      'note': instance.note,
      'bill_date': instance.billDate,
      'created_at': instance.createdAt,
    };