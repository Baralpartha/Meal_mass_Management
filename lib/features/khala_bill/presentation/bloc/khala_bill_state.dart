import 'package:equatable/equatable.dart';
import '../../domain/entities/khala_bill_entity.dart';

abstract class KhalaBillState extends Equatable {
  const KhalaBillState();
  @override
  List<Object?> get props => [];
}

class KhalaBillInitial extends KhalaBillState {
  const KhalaBillInitial();
}

class KhalaBillLoading extends KhalaBillState {
  const KhalaBillLoading();
}

class KhalaBillLoaded extends KhalaBillState {
  final List<KhalaBillEntity> bills;
  const KhalaBillLoaded(this.bills);
  @override
  List<Object?> get props => [bills];
}

class KhalaBillActionSuccess extends KhalaBillState {
  final String message;
  final List<KhalaBillEntity> bills;
  const KhalaBillActionSuccess({required this.message, required this.bills});
  @override
  List<Object?> get props => [message, bills];
}

class KhalaBillError extends KhalaBillState {
  final String message;
  const KhalaBillError(this.message);
  @override
  List<Object?> get props => [message];
}
