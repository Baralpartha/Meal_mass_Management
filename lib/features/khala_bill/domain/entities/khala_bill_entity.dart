import 'package:equatable/equatable.dart';

class KhalaBillEntity extends Equatable {
  final String id;
  final String? cycleId;
  final String memberId;
  final double amount;
  final String? note;
  final DateTime billDate;
  final DateTime createdAt;

  const KhalaBillEntity({
    required this.id,
    this.cycleId,
    required this.memberId,
    required this.amount,
    this.note,
    required this.billDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, cycleId, memberId, amount, note, billDate, createdAt,
  ];
}