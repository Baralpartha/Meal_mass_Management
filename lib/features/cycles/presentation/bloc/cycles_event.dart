import 'package:equatable/equatable.dart';

abstract class CyclesEvent extends Equatable {
  const CyclesEvent();
  @override
  List<Object?> get props => [];
}

class CyclesLoadAll extends CyclesEvent {
  const CyclesLoadAll();
}

class CyclesLoadRunning extends CyclesEvent {
  const CyclesLoadRunning();
}

class CyclesStart extends CyclesEvent {
  final String adminId;
  final String cycleCode;
  final String startDate;
  const CyclesStart(
      {required this.adminId,
        required this.cycleCode,
        required this.startDate});
  @override
  List<Object?> get props => [adminId, cycleCode, startDate];
}

class CyclesClose extends CyclesEvent {
  final String adminId;
  final String cycleId;
  final String endDate;
  const CyclesClose(
      {required this.adminId, required this.cycleId, required this.endDate});
  @override
  List<Object?> get props => [adminId, cycleId, endDate];
}