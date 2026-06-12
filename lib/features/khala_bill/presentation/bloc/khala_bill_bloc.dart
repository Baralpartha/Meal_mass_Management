import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/khala_bill_usecases.dart';
import 'khala_bill_event.dart';
import 'khala_bill_state.dart';

@injectable
class KhalaBillBloc extends Bloc<KhalaBillEvent, KhalaBillState> {
  final GetKhalaBillsByCycleUseCase _getByCycle;
  final GetKhalaBillsByMemberUseCase _getByMember;
  final AddKhalaBillUseCase _addBill;
  final DeleteKhalaBillUseCase _deleteBill;

  KhalaBillBloc(
    this._getByCycle,
    this._getByMember,
    this._addBill,
    this._deleteBill,
  ) : super(const KhalaBillInitial()) {
    on<KhalaBillLoadByCycle>(_onLoadByCycle);
    on<KhalaBillLoadByMember>(_onLoadByMember);
    on<KhalaBillAdd>(_onAdd);
    on<KhalaBillDelete>(_onDelete);
  }

  Future<void> _onLoadByCycle(
      KhalaBillLoadByCycle event, Emitter<KhalaBillState> emit) async {
    emit(const KhalaBillLoading());
    final result = await _getByCycle(GetKhalaBillsByCycleParams(event.cycleId));
    result.fold(
      (f) => emit(KhalaBillError(f.message)),
      (bills) => emit(KhalaBillLoaded(bills)),
    );
  }

  Future<void> _onLoadByMember(
      KhalaBillLoadByMember event, Emitter<KhalaBillState> emit) async {
    emit(const KhalaBillLoading());
    final result =
        await _getByMember(GetKhalaBillsByMemberParams(event.memberId));
    result.fold(
      (f) => emit(KhalaBillError(f.message)),
      (bills) => emit(KhalaBillLoaded(bills)),
    );
  }

  Future<void> _onAdd(KhalaBillAdd event, Emitter<KhalaBillState> emit) async {
    emit(const KhalaBillLoading());
    final result = await _addBill(AddKhalaBillParams(
      adminId: event.adminId,
      cycleId: event.cycleId,
      memberId: event.memberId,
      amount: event.amount,
      note: event.note,
      billDate: event.billDate,
    ));
    await result.fold(
      (f) async => emit(KhalaBillError(f.message)),
      (_) async {
        final refreshed =
            await _getByCycle(GetKhalaBillsByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(KhalaBillError(f.message)),
          (bills) => emit(KhalaBillActionSuccess(
              message: 'Khala bill added successfully', bills: bills)),
        );
      },
    );
  }

  Future<void> _onDelete(
      KhalaBillDelete event, Emitter<KhalaBillState> emit) async {
    emit(const KhalaBillLoading());
    final result = await _deleteBill(DeleteKhalaBillParams(event.billId));
    await result.fold(
      (f) async => emit(KhalaBillError(f.message)),
      (_) async {
        final refreshed =
            await _getByCycle(GetKhalaBillsByCycleParams(event.cycleId));
        refreshed.fold(
          (f) => emit(KhalaBillError(f.message)),
          (bills) =>
              emit(KhalaBillActionSuccess(message: 'Bill deleted', bills: bills)),
        );
      },
    );
  }
}
