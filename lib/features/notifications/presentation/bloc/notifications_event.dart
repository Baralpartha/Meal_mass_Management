import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

class NotificationsLoad extends NotificationsEvent {
  final String memberId;
  const NotificationsLoad(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

class NotificationsMarkRead extends NotificationsEvent {
  final String notificationId;
  final String memberId;
  const NotificationsMarkRead(
      {required this.notificationId, required this.memberId});
  @override
  List<Object?> get props => [notificationId];
}

class NotificationsMarkAllRead extends NotificationsEvent {
  final String memberId;
  const NotificationsMarkAllRead(this.memberId);
  @override
  List<Object?> get props => [memberId];
}
