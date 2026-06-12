import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetAdminDashboardUseCase _getAdminDashboard;
  final GetMemberDashboardUseCase _getMemberDashboard;

  DashboardBloc(this._getAdminDashboard, this._getMemberDashboard)
      : super(const DashboardInitial()) {
    on<DashboardLoadAdmin>(_onLoadAdmin);
    on<DashboardLoadMember>(_onLoadMember);
  }

  Future<void> _onLoadAdmin(
      DashboardLoadAdmin event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    final result =
        await _getAdminDashboard(GetAdminDashboardParams(event.adminId));
    result.fold(
      (f) => emit(DashboardError(f.message)),
      (data) => emit(AdminDashboardLoaded(data)),
    );
  }

  Future<void> _onLoadMember(
      DashboardLoadMember event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    final result =
        await _getMemberDashboard(GetMemberDashboardParams(event.memberId));
    result.fold(
      (f) => emit(DashboardError(f.message)),
      (balances) => emit(MemberDashboardLoaded(balances)),
    );
  }
}
