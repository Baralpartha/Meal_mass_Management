import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String? memberId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    this.memberId,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, memberId, title, message, isRead, createdAt];
}