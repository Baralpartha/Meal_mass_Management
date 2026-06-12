import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/reports_usecases.dart';
import 'reports_event.dart';
import 'reports_state.dart';

@injectable
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetCycleSummariesUseCase _getCycleSummaries;
  final GetMemberBalanceViewUseCase _getMemberBalanceView;
  final GetAllMemberBalancesUseCase _getAllMemberBalances;

  ReportsBloc(
    this._getCycleSummaries,
    this._getMemberBalanceView,
    this._getAllMemberBalances,
  ) : super(const ReportsInitial()) {
    on<ReportsLoadCycleSummary>(_onLoadCycleSummary);
    on<ReportsLoadMemberBalance>(_onLoadMemberBalance);
    on<ReportsLoadAllBalances>(_onLoadAllBalances);
  }

  Future<void> _onLoadCycleSummary(
      ReportsLoadCycleSummary event, Emitter<ReportsState> emit) async {
    emit(const ReportsLoading());
    final result =
        await _getCycleSummaries(GetCycleSummariesParams(event.cycleId));
    result.fold(
      (f) => emit(ReportsError(f.message)),
      (summaries) => emit(ReportsCycleSummaryLoaded(summaries)),
    );
  }

  Future<void> _onLoadMemberBalance(
      ReportsLoadMemberBalance event, Emitter<ReportsState> emit) async {
    emit(const ReportsLoading());
    final result =
        await _getMemberBalanceView(GetMemberBalanceViewParams(event.cycleId));
    result.fold(
      (f) => emit(ReportsError(f.message)),
      (balances) => emit(ReportsMemberBalanceLoaded(balances)),
    );
  }

  Future<void> _onLoadAllBalances(
      ReportsLoadAllBalances event, Emitter<ReportsState> emit) async {
    emit(const ReportsLoading());
    final result = await _getAllMemberBalances();
    result.fold(
      (f) => emit(ReportsError(f.message)),
      (balances) => emit(ReportsMemberBalanceLoaded(balances)),
    );
  }
}
