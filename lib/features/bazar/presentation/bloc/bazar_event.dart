import 'package:equatable/equatable.dart';

abstract class BazarEvent extends Equatable {
  const BazarEvent();
  @override
  List<Object?> get props => [];
}

class BazarLoadByCycle extends BazarEvent {
  final String cycleId;
  const BazarLoadByCycle(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class BazarLoadByMember extends BazarEvent {
  final String memberId;
  const BazarLoadByMember(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

class BazarAdd extends BazarEvent {
  final String adminId;
  final String cycleId;
  final String memberId;
  final String description;
  final double amount;
  final String? quantity;
  final String bazarDate;
  const BazarAdd({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.description,
    required this.amount,
    this.quantity,
    required this.bazarDate,
  });
  @override
  List<Object?> get props => [cycleId, memberId, description, amount];
}

class BazarDelete extends BazarEvent {
  final String bazarId;
  final String cycleId;
  const BazarDelete({required this.bazarId, required this.cycleId});
  @override
  List<Object?> get props => [bazarId];
}
