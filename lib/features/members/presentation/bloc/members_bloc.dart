import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/members_usecase.dart';
import 'members_event.dart';
import 'members_state.dart';

@injectable
class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final GetAllMembersUseCase _getAllMembers;
  final GetMembersByStatusUseCase _getMembersByStatus;
  final ApproveMemberUseCase _approveMember;
  final RejectMemberUseCase _rejectMember;

  MembersBloc(
      this._getAllMembers,
      this._getMembersByStatus,
      this._approveMember,
      this._rejectMember,
      ) : super(const MembersInitial()) {
    on<MembersLoadAll>(_onLoadAll);
    on<MembersLoadByStatus>(_onLoadByStatus);
    on<MembersApprove>(_onApprove);
    on<MembersReject>(_onReject);
  }

  Future<void> _onLoadAll(
      MembersLoadAll event, Emitter<MembersState> emit) async {
    emit(const MembersLoading());
    final result = await _getAllMembers();
    result.fold(
          (f) => emit(MembersError(f.message)),
          (members) => emit(MembersLoaded(members)),
    );
  }

  Future<void> _onLoadByStatus(
      MembersLoadByStatus event, Emitter<MembersState> emit) async {
    emit(const MembersLoading());
    final result = await _getMembersByStatus(GetMembersByStatusParams(event.status));
    result.fold(
          (f) => emit(MembersError(f.message)),
          (members) => emit(MembersLoaded(members)),
    );
  }

  Future<void> _onApprove(
      MembersApprove event, Emitter<MembersState> emit) async {
    emit(const MembersLoading());
    final result = await _approveMember(
        ApproveMemberParams(adminId: event.adminId, memberId: event.memberId));
    await result.fold(
          (f) async => emit(MembersError(f.message)),
          (_) async {
        final refreshed = await _getAllMembers();
        refreshed.fold(
              (f) => emit(MembersError(f.message)),
              (members) => emit(MembersActionSuccess(
              message: 'Member approved successfully', members: members)),
        );
      },
    );
  }

  Future<void> _onReject(
      MembersReject event, Emitter<MembersState> emit) async {
    emit(const MembersLoading());
    final result = await _rejectMember(
        RejectMemberParams(adminId: event.adminId, memberId: event.memberId));
    await result.fold(
          (f) async => emit(MembersError(f.message)),
          (_) async {
        final refreshed = await _getAllMembers();
        refreshed.fold(
              (f) => emit(MembersError(f.message)),
              (members) => emit(MembersActionSuccess(
              message: 'Member rejected', members: members)),
        );
      },
    );
  }
}