import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsParams extends Equatable {
  final String memberId;
  const GetNotificationsParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationsRepository _repository;
  GetNotificationsUseCase(this._repository);
  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
          GetNotificationsParams params) =>
      _repository.getNotificationsForMember(params.memberId);
}

class MarkAsReadParams extends Equatable {
  final String notificationId;
  const MarkAsReadParams(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

@lazySingleton
class MarkNotificationReadUseCase implements UseCase<void, MarkAsReadParams> {
  final NotificationsRepository _repository;
  MarkNotificationReadUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) =>
      _repository.markAsRead(params.notificationId);
}

class MarkAllReadParams extends Equatable {
  final String memberId;
  const MarkAllReadParams(this.memberId);
  @override
  List<Object?> get props => [memberId];
}

@lazySingleton
class MarkAllNotificationsReadUseCase
    implements UseCase<void, MarkAllReadParams> {
  final NotificationsRepository _repository;
  MarkAllNotificationsReadUseCase(this._repository);
  @override
  Future<Either<Failure, void>> call(MarkAllReadParams params) =>
      _repository.markAllAsRead(params.memberId);
}
