import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/bazar_usecases.dart';
import 'bazar_event.dart';
import 'bazar_state.dart';

@injectable
class BazarBloc extends Bloc<BazarEvent, BazarState> {
  final GetBazarByCycleUseCase _getByCycle;
  final GetBazarByMemberUseCase _getByMember;
  final AddBazarUseCase _addBazar;
  final DeleteBazarUseCase _deleteBazar;

  BazarBloc(
    this._getByCycle,
    this._getByMember,
    this._addBazar,
    this._deleteBazar,
  ) : super(const BazarInitial()) {
    on<BazarLoadByCycle>(_onLoadByCycle);
    on<BazarLoadByMember>(_onLoadByMember);
    on<BazarAdd>(_onAdd);
    on<BazarDelete>(_onDelete);
  }

  Future<void> _onLoadByCycle(
      BazarLoadByCycle event, Emitter<BazarState> emit) async {
    emit(const BazarLoading());
    final result = await _getByCycle(GetBazarByCycleParams(event.cycleId));
    result.fold(
      (f) => emit(BazarError(f.message)),
      (entries) => emit(BazarLoaded(entries)),
    );
  }

  Future<void> _onLoadByMember(
      BazarLoadByMember event, Emitter<BazarState> emit) async {
    emit(const BazarLoading());
    final result = await _getByMember(GetBazarByMemberParams(event.memberId));
    result.fold(
      (f) => emit(BazarError(f.message)),
      (entries) => emit(BazarLoaded(entries)),
    );
  }

  Future<void> _onAdd(BazarAdd event, Emitter<BazarState> emit) async {
    emit(const BazarLoading());
    final result = await _addBazar(AddBazarParams(
      adminId: event.adminId,
      cycleId: event.cycleId,
      memberId: event.memberId,
      description: event.description,
      amount: event.amount,
      quantity: event.quantity,
      bazarDate: event.bazarDate,
    ));
    await result.fold(
      (f) async => emit(BazarError(f.message)),
      (_) async {
        final refreshed = await _getByCycle(GetBazarByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(BazarError(f.message)),
          (entries) => emit(BazarActionSuccess(
              message: 'Bazar entry added', entries: entries)),
        );
      },
    );
  }

  Future<void> _onDelete(BazarDelete event, Emitter<BazarState> emit) async {
    emit(const BazarLoading());
    final result = await _deleteBazar(DeleteBazarParams(event.bazarId));
    await result.fold(
      (f) async => emit(BazarError(f.message)),
      (_) async {
        final refreshed = await _getByCycle(GetBazarByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(BazarError(f.message)),
          (entries) =>
              emit(BazarActionSuccess(message: 'Bazar entry deleted', entries: entries)),
        );
      },
    );
  }
}
