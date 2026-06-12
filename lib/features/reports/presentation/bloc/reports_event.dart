import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();
  @override
  List<Object?> get props => [];
}

class ReportsLoadCycleSummary extends ReportsEvent {
  final String cycleId;
  const ReportsLoadCycleSummary(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class ReportsLoadMemberBalance extends ReportsEvent {
  final String cycleId;
  const ReportsLoadMemberBalance(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class ReportsLoadAllBalances extends ReportsEvent {
  const ReportsLoadAllBalances();
}
