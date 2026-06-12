import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardLoadAdmin extends DashboardEvent {
  final String adminId;
  const DashboardLoadAdmin(this.adminId);
  @override
  List<Object?> get props => [adminId];
}

class DashboardLoadMember extends DashboardEvent {
  final String memberId;
  const DashboardLoadMember(this.memberId);
  @override
  List<Object?> get props => [memberId];
}
