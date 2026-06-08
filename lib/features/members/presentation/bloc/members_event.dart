import 'package:equatable/equatable.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();
  @override
  List<Object?> get props => [];
}

class MembersLoadAll extends MembersEvent {
  const MembersLoadAll();
}

class MembersLoadByStatus extends MembersEvent {
  final String status;
  const MembersLoadByStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class MembersApprove extends MembersEvent {
  final String adminId;
  final String memberId;
  const MembersApprove({required this.adminId, required this.memberId});
  @override
  List<Object?> get props => [adminId, memberId];
}

class MembersReject extends MembersEvent {
  final String adminId;
  final String memberId;
  const MembersReject({required this.adminId, required this.memberId});
  @override
  List<Object?> get props => [adminId, memberId];
}