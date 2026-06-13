import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';

class MembersListPage extends StatefulWidget {
  const MembersListPage({super.key});

  @override
  State<MembersListPage> createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _tabs_labels = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String? get _adminId {
    final state = sl<AuthBloc>().state;
    return state is AuthAuthenticated ? state.member.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MembersBloc>()..add(const MembersLoadAll()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Members'),
          bottom: TabBar(
            controller: _tabs,
            tabs: _tabs_labels.map((t) => Tab(text: t)).toList(),
            isScrollable: true,
            labelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
        ),
        body: BlocConsumer<MembersBloc, MembersState>(
          listener: (context, state) {
            if (state is MembersActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is MembersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is MembersLoading) {
              return const AppLoading();
            }
            if (state is MembersError && state is! MembersLoaded) {
              return AppError(
                message: (state as MembersError).message,
                onRetry: () => context
                    .read<MembersBloc>()
                    .add(const MembersLoadAll()),
              );
            }

            final members = state is MembersLoaded
                ? state.members
                : state is MembersActionSuccess
                    ? state.members
                    : <MemberEntity>[];

            return TabBarView(
              controller: _tabs,
              children: [
                _MembersList(
                  members: members,
                  adminId: _adminId,
                ),
                _MembersList(
                  members: members
                      .where((m) => m.status == MemberStatus.pending)
                      .toList(),
                  adminId: _adminId,
                  showActions: true,
                ),
                _MembersList(
                  members: members
                      .where((m) => m.status == MemberStatus.approved)
                      .toList(),
                  adminId: _adminId,
                ),
                _MembersList(
                  members: members
                      .where((m) => m.status == MemberStatus.rejected)
                      .toList(),
                  adminId: _adminId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List<MemberEntity> members;
  final String? adminId;
  final bool showActions;

  const _MembersList({
    required this.members,
    this.adminId,
    this.showActions = false,
  });

  Color _statusColor(MemberStatus s) {
    switch (s) {
      case MemberStatus.approved:
        return AppTheme.success;
      case MemberStatus.pending:
        return AppTheme.warning;
      case MemberStatus.rejected:
        return AppTheme.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const AppEmpty(message: 'No members in this category');
    }
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<MembersBloc>().add(const MembersLoadAll()),
      child: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, i) {
          final m = members[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: Text(m.fullName[0].toUpperCase(),
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700)),
              ),
              title: Text(m.fullName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.mobileNumber,
                      style: const TextStyle(fontSize: 12)),
                  if (m.district != null)
                    Text(m.district!,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(m.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      m.status.name.toUpperCase(),
                      style: TextStyle(
                          color: _statusColor(m.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              onLongPress: showActions && adminId != null
                  ? () => _showActionSheet(context, m)
                  : null,
              onTap: () => context.push('/members/${m.id}'),
            ),
          );
        },
      ),
    );
  }

  void _showActionSheet(BuildContext context, MemberEntity member) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(member.fullName,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: AppTheme.success),
              title: const Text('Approve Member'),
              onTap: () {
                Navigator.pop(context);
                context.read<MembersBloc>().add(MembersApprove(
                    adminId: adminId!, memberId: member.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined,
                  color: AppTheme.error),
              title: const Text('Reject Member'),
              onTap: () {
                Navigator.pop(context);
                context.read<MembersBloc>().add(MembersReject(
                    adminId: adminId!, memberId: member.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
