import 'package:equatable/equatable.dart';

abstract class DepositsEvent extends Equatable {
  const DepositsEvent();
  @override
  List<Object?> get props => [];
}

class DepositsLoadByCycle extends DepositsEvent {
  final String cycleId;
  const DepositsLoadByCycle(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class DepositsLoadByMember extends DepositsEvent {
  final String memberId;
  const DepositsLoadByMember(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

class DepositsAdd extends DepositsEvent {
  final String adminId;
  final String cycleId;
  final String memberId;
  final double amount;
  final String depositDate;
  final String? note;
  const DepositsAdd({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    required this.depositDate,
    this.note,
  });
  @override
  List<Object?> get props => [cycleId, memberId, amount, depositDate];
}

class DepositsDelete extends DepositsEvent {
  final String depositId;
  final String cycleId;
  const DepositsDelete({required this.depositId, required this.cycleId});
  @override
  List<Object?> get props => [depositId];
}
