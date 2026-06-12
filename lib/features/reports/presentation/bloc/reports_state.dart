import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/admin_dashbord_entity.dart';
import '../../domain/entities/cycle_member_summary_entity.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsCycleSummaryLoaded extends ReportsState {
  final List<CycleMemberSummaryEntity> summaries;
  const ReportsCycleSummaryLoaded(this.summaries);
  @override
  List<Object?> get props => [summaries];
}

class ReportsMemberBalanceLoaded extends ReportsState {
  final List<MemberBalanceEntity> balances;
  const ReportsMemberBalanceLoaded(this.balances);
  @override
  List<Object?> get props => [balances];
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
  @override
  List<Object?> get props => [message];
}
