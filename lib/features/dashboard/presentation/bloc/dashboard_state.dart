import 'package:equatable/equatable.dart';

import '../../domain/entities/admin_dashbord_entity.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class AdminDashboardLoaded extends DashboardState {
  final AdminDashboardEntity data;
  const AdminDashboardLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class MemberDashboardLoaded extends DashboardState {
  final List<MemberBalanceEntity> balances;
  const MemberDashboardLoaded(this.balances);
  @override
  List<Object?> get props => [balances];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
