import 'package:equatable/equatable.dart';
import '../../domain/entities/bazar_entry_entity.dart';

abstract class BazarState extends Equatable {
  const BazarState();
  @override
  List<Object?> get props => [];
}

class BazarInitial extends BazarState {
  const BazarInitial();
}

class BazarLoading extends BazarState {
  const BazarLoading();
}

class BazarLoaded extends BazarState {
  final List<BazarEntryEntity> entries;
  const BazarLoaded(this.entries);
  @override
  List<Object?> get props => [entries];
}

class BazarActionSuccess extends BazarState {
  final String message;
  final List<BazarEntryEntity> entries;
  const BazarActionSuccess({required this.message, required this.entries});
  @override
  List<Object?> get props => [message, entries];
}

class BazarError extends BazarState {
  final String message;
  const BazarError(this.message);
  @override
  List<Object?> get props => [message];
}
