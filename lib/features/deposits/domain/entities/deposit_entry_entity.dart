import 'package:equatable/equatable.dart';

class DepositEntryEntity extends Equatable {
  final String id;
  final String cycleId;
  final String memberId;
  final double amount;
  final DateTime depositDate;
  final String? note;
  final DateTime createdAt;

  const DepositEntryEntity({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.amount,
    required this.depositDate,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, cycleId, memberId, amount, depositDate, note, createdAt,
  ];
}