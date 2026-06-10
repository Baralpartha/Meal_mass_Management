import 'package:equatable/equatable.dart';
import '../../domain/entities/deposit_entry_entity.dart';

abstract class DepositsState extends Equatable {
  const DepositsState();
  @override
  List<Object?> get props => [];
}

class DepositsInitial extends DepositsState {
  const DepositsInitial();
}

class DepositsLoading extends DepositsState {
  const DepositsLoading();
}

class DepositsLoaded extends DepositsState {
  final List<DepositEntryEntity> deposits;
  const DepositsLoaded(this.deposits);
  @override
  List<Object?> get props => [deposits];
}

class DepositsActionSuccess extends DepositsState {
  final String message;
  final List<DepositEntryEntity> deposits;
  const DepositsActionSuccess({required this.message, required this.deposits});
  @override
  List<Object?> get props => [message, deposits];
}

class DepositsError extends DepositsState {
  final String message;
  const DepositsError(this.message);
  @override
  List<Object?> get props => [message];
}
