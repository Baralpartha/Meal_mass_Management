// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      memberId: json['member_id'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
    };