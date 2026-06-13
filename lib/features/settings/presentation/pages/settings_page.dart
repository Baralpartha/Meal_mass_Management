import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = sl<AuthBloc>().state;
    final member =
        authState is AuthAuthenticated ? authState.member : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Profile card
          if (member != null) _ProfileCard(member: member),
          const SizedBox(height: 8),

          // Account section
          _SectionHeader('Account'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: member?.fullName ?? '',
            onTap: () {
              if (member != null) {
                context.push('/members/${member.id}');
              }
            },
          ),
          _SettingsTile(
            icon: Icons.phone_outlined,
            title: 'Mobile Number',
            subtitle: member?.mobileNumber ?? '',
          ),
          _SettingsTile(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Role',
            subtitle: member?.role.name.toUpperCase() ?? '',
          ),
          _SettingsTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Opening Balance',
            subtitle: member?.openingBalance.toCurrencyBDT() ?? '৳0.00',
          ),

          const SizedBox(height: 8),
          _SectionHeader('App'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
          ),
          _SettingsTile(
            icon: Icons.code,
            title: 'Built with',
            subtitle: 'Flutter + Supabase + BLoC',
          ),

          const SizedBox(height: 8),
          _SectionHeader('Actions'),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFFEBEE),
              child:
                  Icon(Icons.logout, color: AppTheme.error, size: 20),
            ),
            title: const Text('Logout',
                style: TextStyle(
                    color: AppTheme.error,
                    fontWeight: FontWeight.w600)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (dCtx) => AlertDialog(
                  title: const Text('Logout'),
                  content:
                      const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(dCtx, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(dCtx, true),
                        child: const Text('Logout',
                            style:
                                TextStyle(color: AppTheme.error))),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                sl<AuthBloc>().add(const AuthLogoutRequested());
                context.go(AppRoutes.login);
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final MemberEntity member;
  const _ProfileCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              member.fullName[0].toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.fullName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                Text(member.mobileNumber,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    member.role.name.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.8)),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.08),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey))
            : null,
        trailing:
            onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      );
}
