import 'package:equatable/equatable.dart';
import '../../domain/entities/cycle_entity.dart';

abstract class CyclesState extends Equatable {
  const CyclesState();
  @override
  List<Object?> get props => [];
}

class CyclesInitial extends CyclesState {
  const CyclesInitial();
}

class CyclesLoading extends CyclesState {
  const CyclesLoading();
}

class CyclesLoaded extends CyclesState {
  final List<CycleEntity> cycles;
  final CycleEntity? runningCycle;
  const CyclesLoaded({required this.cycles, this.runningCycle});
  @override
  List<Object?> get props => [cycles, runningCycle];
}

class CyclesActionSuccess extends CyclesState {
  final String message;
  const CyclesActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CyclesError extends CyclesState {
  final String message;
  const CyclesError(this.message);
  @override
  List<Object?> get props => [message];
}