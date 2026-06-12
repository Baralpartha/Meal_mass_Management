import 'package:equatable/equatable.dart';

abstract class KhalaBillEvent extends Equatable {
  const KhalaBillEvent();
  @override
  List<Object?> get props => [];
}

class KhalaBillLoadByCycle extends KhalaBillEvent {
  final String cycleId;
  const KhalaBillLoadByCycle(this.cycleId);
  @override
  List<Object?> get props => [cycleId];
}

class KhalaBillLoadByMember extends KhalaBillEvent {
  final String memberId;
  const KhalaBillLoadByMember(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

class KhalaBillAdd extends KhalaBillEvent {
  final String adminId;
  final String cycleId;
  final String memberId;
  final double amount;
  final String? note;
  final String billDate;
  const KhalaBillAdd({
    required this.adminId,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    this.note,
    required this.billDate,
  });
  @override
  List<Object?> get props => [cycleId, memberId, amount, billDate];
}

class KhalaBillDelete extends KhalaBillEvent {
  final String billId;
  final String cycleId;
  const KhalaBillDelete({required this.billId, required this.cycleId});
  @override
  List<Object?> get props => [billId];
}
