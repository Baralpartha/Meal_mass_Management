import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/member_entity.dart';

part 'member_model.g.dart';

@JsonSerializable()
class MemberModel {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  final String? district;
  final String? thana;
  final String? address;
  final String? password;
  final String role;
  final String status;
  @JsonKey(name: 'opening_balance')
  final double openingBalance;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const MemberModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    this.district,
    this.thana,
    this.address,
    this.password,
    required this.role,
    required this.status,
    required this.openingBalance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

  MemberEntity toEntity() => MemberEntity(
    id: id,
    fullName: fullName,
    mobileNumber: mobileNumber,
    district: district,
    thana: thana,
    address: address,
    role: _parseRole(role),
    status: _parseStatus(status),
    openingBalance: openingBalance,
    isActive: isActive,
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );

  static MemberRole _parseRole(String role) {
    switch (role) {
      case 'admin':
        return MemberRole.admin;
      default:
        return MemberRole.member;
    }
  }

  static MemberStatus _parseStatus(String status) {
    switch (status) {
      case 'approved':
        return MemberStatus.approved;
      case 'rejected':
        return MemberStatus.rejected;
      case 'inactive':
        return MemberStatus.inactive;
      default:
        return MemberStatus.pending;
    }
  }

  Map<String, dynamic> toInsertJson() => {
    'full_name': fullName,
    'mobile_number': mobileNumber,
    if (district != null) 'district': district,
    if (thana != null) 'thana': thana,
    if (address != null) 'address': address,
    if (password != null) 'password': password,
    'role': role,
    'status': status,
    'opening_balance': openingBalance,
    'is_active': isActive,
  };
}