import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/cycles_usecase.dart';
import 'cycles_event.dart';
import 'cycles_state.dart';

@injectable
class CyclesBloc extends Bloc<CyclesEvent, CyclesState> {
  final GetAllCyclesUseCase _getAllCycles;
  final GetRunningCycleUseCase _getRunningCycle;
  final StartNewCycleUseCase _startNewCycle;
  final CloseCycleUseCase _closeCycle;

  CyclesBloc(
      this._getAllCycles,
      this._getRunningCycle,
      this._startNewCycle,
      this._closeCycle,
      ) : super(const CyclesInitial()) {
    on<CyclesLoadAll>(_onLoadAll);
    on<CyclesLoadRunning>(_onLoadRunning);
    on<CyclesStart>(_onStart);
    on<CyclesClose>(_onClose);
  }

  Future<void> _onLoadAll(CyclesLoadAll event, Emitter<CyclesState> emit) async {
    emit(const CyclesLoading());
    final cyclesResult = await _getAllCycles();
    final runningResult = await _getRunningCycle();
    cyclesResult.fold(
          (f) => emit(CyclesError(f.message)),
          (cycles) => runningResult.fold(
            (f) => emit(CyclesLoaded(cycles: cycles)),
            (running) => emit(CyclesLoaded(cycles: cycles, runningCycle: running)),
      ),
    );
  }

  Future<void> _onLoadRunning(
      CyclesLoadRunning event, Emitter<CyclesState> emit) async {
    emit(const CyclesLoading());
    final result = await _getRunningCycle();
    result.fold(
          (f) => emit(CyclesError(f.message)),
          (running) => emit(CyclesLoaded(cycles: [], runningCycle: running)),
    );
  }

  Future<void> _onStart(CyclesStart event, Emitter<CyclesState> emit) async {
    emit(const CyclesLoading());
    final result = await _startNewCycle(StartNewCycleParams(
        adminId: event.adminId,
        cycleCode: event.cycleCode,
        startDate: event.startDate));
    result.fold(
          (f) => emit(CyclesError(f.message)),
          (msg) => emit(CyclesActionSuccess(msg)),
    );
  }

  Future<void> _onClose(CyclesClose event, Emitter<CyclesState> emit) async {
    emit(const CyclesLoading());
    final result = await _closeCycle(CloseCycleParams(
        adminId: event.adminId,
        cycleId: event.cycleId,
        endDate: event.endDate));
    result.fold(
          (f) => emit(CyclesError(f.message)),
          (msg) => emit(CyclesActionSuccess(msg)),
    );
  }
}