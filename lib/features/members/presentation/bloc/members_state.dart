import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/member_entity.dart';

abstract class MembersState extends Equatable {
  const MembersState();
  @override
  List<Object?> get props => [];
}

class MembersInitial extends MembersState {
  const MembersInitial();
}

class MembersLoading extends MembersState {
  const MembersLoading();
}

class MembersLoaded extends MembersState {
  final List<MemberEntity> members;
  const MembersLoaded(this.members);
  @override
  List<Object?> get props => [members];
}

class MembersActionSuccess extends MembersState {
  final String message;
  final List<MemberEntity> members;
  const MembersActionSuccess({required this.message, required this.members});
  @override
  List<Object?> get props => [message, members];
}

class MembersError extends MembersState {
  final String message;
  const MembersError(this.message);
  @override
  List<Object?> get props => [message];
}