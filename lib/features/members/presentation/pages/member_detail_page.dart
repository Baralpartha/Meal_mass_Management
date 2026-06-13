import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';

class MemberDetailPage extends StatelessWidget {
  final String memberId;
  const MemberDetailPage({super.key, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MembersBloc>()
        ..add(MembersLoadByStatus('approved')),
      child: Scaffold(
        appBar: AppBar(title: const Text('Member Details')),
        body: BlocBuilder<MembersBloc, MembersState>(
          builder: (context, state) {
            if (state is MembersLoading) return const AppLoading();
            if (state is MembersError) {
              return AppError(message: state.message);
            }
            if (state is MembersLoaded) {
              final member = state.members
                  .where((m) => m.id == memberId)
                  .cast<MemberEntity?>()
                  .firstOrNull;
              if (member == null) {
                return const AppError(message: 'Member not found');
              }
              return _MemberDetailBody(member: member);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _MemberDetailBody extends StatelessWidget {
  final MemberEntity member;
  const _MemberDetailBody({required this.member});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppTheme.primary.withOpacity(0.1),
            child: Text(
              member.fullName[0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(member.fullName,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800)),
          Text(member.mobileNumber,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          _StatusBadge(member.status),
          const SizedBox(height: 24),
          _InfoRow('Role', member.role.name.toUpperCase()),
          if (member.district != null)
            _InfoRow('District', member.district!),
          if (member.thana != null) _InfoRow('Thana', member.thana!),
          if (member.address != null)
            _InfoRow('Address', member.address!),
          _InfoRow('Opening Balance',
              member.openingBalance.toCurrencyBDT()),
          _InfoRow('Active', member.isActive ? 'Yes' : 'No'),
          _InfoRow('Member Since',
              '${member.createdAt.day}/${member.createdAt.month}/${member.createdAt.year}'),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final MemberStatus status;
  const _StatusBadge(this.status);

  Color get _color {
    switch (status) {
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
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(status.name.toUpperCase(),
            style: TextStyle(
                color: _color,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      );
}
