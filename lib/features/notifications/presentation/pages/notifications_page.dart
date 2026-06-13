import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/date_extention.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = sl<AuthBloc>().state;
    final memberId =
        authState is AuthAuthenticated ? authState.member.id : '';

    return BlocProvider(
      create: (_) => sl<NotificationsBloc>()
        ..add(NotificationsLoad(memberId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                final hasUnread = state is NotificationsLoaded &&
                    state.notifications.any((n) => !n.isRead);
                if (!hasUnread) return const SizedBox.shrink();
                return TextButton(
                  onPressed: () => context
                      .read<NotificationsBloc>()
                      .add(NotificationsMarkAllRead(memberId)),
                  child: const Text('Mark all read',
                      style: TextStyle(color: Colors.white)),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) return const AppLoading();
            if (state is NotificationsError) {
              return AppError(
                message: state.message,
                onRetry: () => context
                    .read<NotificationsBloc>()
                    .add(NotificationsLoad(memberId)),
              );
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return const AppEmpty(
                  message: 'No notifications yet',
                  icon: Icons.notifications_off_outlined,
                );
              }
              return RefreshIndicator(
                onRefresh: () async => context
                    .read<NotificationsBloc>()
                    .add(NotificationsLoad(memberId)),
                child: ListView.separated(
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (ctx, i) {
                    final n = state.notifications[i];
                    return _NotificationTile(
                      notification: n,
                      onTap: n.isRead
                          ? null
                          : () => context
                              .read<NotificationsBloc>()
                      // ✅ FIXED
                          .add(NotificationsMarkRead(
                        notificationId: n.id,
                        memberId: memberId,
                      )),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const _NotificationTile({required this.notification, this.onTap});

  IconData _icon() {
    final title = notification.title.toLowerCase();
    if (title.contains('meal')) return Icons.rice_bowl_outlined;
    if (title.contains('deposit')) return Icons.account_balance_wallet_outlined;
    if (title.contains('approve')) return Icons.check_circle_outline;
    if (title.contains('reject')) return Icons.cancel_outlined;
    if (title.contains('cycle')) return Icons.loop;
    if (title.contains('khala')) return Icons.receipt_outlined;
    return Icons.notifications_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: unread
            ? AppTheme.primary.withOpacity(0.04)
            : Colors.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: unread
                  ? AppTheme.primary.withOpacity(0.12)
                  : Colors.grey.shade100,
              child: Icon(
                _icon(),
                size: 18,
                color: unread ? AppTheme.primary : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        notification.createdAt.toTimeAgo(),
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: unread
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
