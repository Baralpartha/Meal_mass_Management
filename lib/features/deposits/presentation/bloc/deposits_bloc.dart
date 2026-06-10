import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/deposits_usecases.dart';
import 'deposits_event.dart';
import 'deposits_state.dart';

@injectable
class DepositsBloc extends Bloc<DepositsEvent, DepositsState> {
  final GetDepositsByCycleUseCase _getByCycle;
  final GetDepositsByMemberUseCase _getByMember;
  final AddDepositUseCase _addDeposit;
  final DeleteDepositUseCase _deleteDeposit;

  DepositsBloc(
    this._getByCycle,
    this._getByMember,
    this._addDeposit,
    this._deleteDeposit,
  ) : super(const DepositsInitial()) {
    on<DepositsLoadByCycle>(_onLoadByCycle);
    on<DepositsLoadByMember>(_onLoadByMember);
    on<DepositsAdd>(_onAdd);
    on<DepositsDelete>(_onDelete);
  }

  Future<void> _onLoadByCycle(
      DepositsLoadByCycle event, Emitter<DepositsState> emit) async {
    emit(const DepositsLoading());
    final result = await _getByCycle(GetDepositsByCycleParams(event.cycleId));
    result.fold(
      (f) => emit(DepositsError(f.message)),
      (deposits) => emit(DepositsLoaded(deposits)),
    );
  }

  Future<void> _onLoadByMember(
      DepositsLoadByMember event, Emitter<DepositsState> emit) async {
    emit(const DepositsLoading());
    final result = await _getByMember(GetDepositsByMemberParams(event.memberId));
    result.fold(
      (f) => emit(DepositsError(f.message)),
      (deposits) => emit(DepositsLoaded(deposits)),
    );
  }

  Future<void> _onAdd(DepositsAdd event, Emitter<DepositsState> emit) async {
    emit(const DepositsLoading());
    final result = await _addDeposit(AddDepositParams(
      adminId: event.adminId,
      cycleId: event.cycleId,
      memberId: event.memberId,
      amount: event.amount,
      depositDate: event.depositDate,
      note: event.note,
    ));
    await result.fold(
      (f) async => emit(DepositsError(f.message)),
      (_) async {
        final refreshed =
            await _getByCycle(GetDepositsByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(DepositsError(f.message)),
          (deposits) => emit(DepositsActionSuccess(
              message: 'Deposit added successfully', deposits: deposits)),
        );
      },
    );
  }

  Future<void> _onDelete(
      DepositsDelete event, Emitter<DepositsState> emit) async {
    emit(const DepositsLoading());
    final result = await _deleteDeposit(DeleteDepositParams(event.depositId));
    await result.fold(
      (f) async => emit(DepositsError(f.message)),
      (_) async {
        final refreshed =
            await _getByCycle(GetDepositsByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(DepositsError(f.message)),
          (deposits) => emit(
              DepositsActionSuccess(message: 'Deposit deleted', deposits: deposits)),
        );
      },
    );
  }
}
