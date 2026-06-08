// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => MemberModel(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  mobileNumber: json['mobile_number'] as String,
  district: json['district'] as String?,
  thana: json['thana'] as String?,
  address: json['address'] as String?,
  password: json['password'] as String?,
  role: json['role'] as String,
  status: json['status'] as String,
  openingBalance: (json['opening_balance'] as num).toDouble(),
  isActive: json['is_active'] as bool,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$MemberModelToJson(MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'mobile_number': instance.mobileNumber,
      'district': instance.district,
      'thana': instance.thana,
      'address': instance.address,
      'password': instance.password,
      'role': instance.role,
      'status': instance.status,
      'opening_balance': instance.openingBalance,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };