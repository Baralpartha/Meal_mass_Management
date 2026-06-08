import 'package:equatable/equatable.dart';

enum MemberRole { admin, member }
enum MemberStatus { pending, approved, rejected, inactive }

extension MemberRoleExtension on MemberRole {
  String get value => name;
  bool get isAdmin => this == MemberRole.admin;
}

extension MemberStatusExtension on MemberStatus {
  String get value => name;
  bool get isApproved => this == MemberStatus.approved;
  bool get isPending => this == MemberStatus.pending;
}

class MemberEntity extends Equatable {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String? district;
  final String? thana;
  final String? address;
  final MemberRole role;
  final MemberStatus status;
  final double openingBalance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MemberEntity({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    this.district,
    this.thana,
    this.address,
    required this.role,
    required this.status,
    required this.openingBalance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == MemberRole.admin;
  bool get isApproved => status == MemberStatus.approved;

  @override
  List<Object?> get props => [
    id, fullName, mobileNumber, district, thana, address,
    role, status, openingBalance, isActive, createdAt, updatedAt,
  ];
}