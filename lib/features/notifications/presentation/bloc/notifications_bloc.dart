import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/notifications_usecases.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

@injectable
class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase _getNotifications;
  final MarkNotificationReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;

  NotificationsBloc(
    this._getNotifications,
    this._markRead,
    this._markAllRead,
  ) : super(const NotificationsInitial()) {
    on<NotificationsLoad>(_onLoad);
    on<NotificationsMarkRead>(_onMarkRead);
    on<NotificationsMarkAllRead>(_onMarkAllRead);
  }

  Future<void> _onLoad(
      NotificationsLoad event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsLoading());
    final result =
        await _getNotifications(GetNotificationsParams(event.memberId));
    result.fold(
      (f) => emit(NotificationsError(f.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> _onMarkRead(
      NotificationsMarkRead event, Emitter<NotificationsState> emit) async {
    await _markRead(MarkAsReadParams(event.notificationId));
    final result =
        await _getNotifications(GetNotificationsParams(event.memberId));
    result.fold(
      (f) => emit(NotificationsError(f.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> _onMarkAllRead(
      NotificationsMarkAllRead event, Emitter<NotificationsState> emit) async {
    await _markAllRead(MarkAllReadParams(event.memberId));
    final result =
        await _getNotifications(GetNotificationsParams(event.memberId));
    result.fold(
      (f) => emit(NotificationsError(f.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }
}
