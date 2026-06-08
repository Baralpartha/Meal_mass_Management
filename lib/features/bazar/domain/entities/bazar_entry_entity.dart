import 'package:equatable/equatable.dart';

class BazarEntryEntity extends Equatable {
  final String id;
  final String cycleId;
  final String memberId;
  final String description;
  final double amount;
  final String? quantity;
  final DateTime bazarDate;
  final DateTime createdAt;

  const BazarEntryEntity({
    required this.id,
    required this.cycleId,
    required this.memberId,
    required this.description,
    required this.amount,
    this.quantity,
    required this.bazarDate,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, cycleId, memberId, description, amount,
    quantity, bazarDate, createdAt,
  ];
}