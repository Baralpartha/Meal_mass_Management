import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../config/env/supabase_service.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotificationsForMember(String memberId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String memberId);
}

@LazySingleton(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final SupabaseService _supabase;
  NotificationsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<NotificationModel>> getNotificationsForMember(
      String memberId) async {
    try {
      final response = await _supabase.rpc(
        AppConstants.getMemberNotificationsFunction,
        params: {'p_member_id': memberId},
      );
      return (response as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from(AppConstants.notificationsTable)
          .update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAllAsRead(String memberId) async {
    try {
      await _supabase
          .from(AppConstants.notificationsTable)
          .update({'is_read': true})
          .eq('member_id', memberId)
          .eq('is_read', false);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
