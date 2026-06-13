import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/info_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();
    final member = (authBloc.state is AuthAuthenticated)
        ? (authBloc.state as AuthAuthenticated).member
        : null;

    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
        ..add(DashboardLoadAdmin(member?.id ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
        drawer: _AdminDrawer(adminName: member?.fullName ?? 'Admin'),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const AppLoading(message: 'Loading dashboard...');
            }
            if (state is DashboardError) {
              return AppError(
                message: state.message,
                onRetry: () => context
                    .read<DashboardBloc>()
                    .add(DashboardLoadAdmin(member?.id ?? '')),
              );
            }
            if (state is AdminDashboardLoaded) {
              final d = state.data;
              return RefreshIndicator(
                onRefresh: () async => context
                    .read<DashboardBloc>()
                    .add(DashboardLoadAdmin(member?.id ?? '')),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Text(
                        'Hello, ${member?.fullName ?? 'Admin'} 👋',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SectionHeader('Current Cycle'),
                    InfoCard(
                      title: 'Meal Rate',
                      value: d.mealRate.toCurrencyBDT(),
                      icon: Icons.rice_bowl_outlined,
                      color: AppTheme.primary,
                    ),
                    InfoCard(
                      title: 'Total Meal Units',
                      value: d.totalMealUnits.toDecimal(),
                      icon: Icons.restaurant_outlined,
                      color: AppTheme.info,
                    ),
                    InfoCard(
                      title: 'Total Bazar',
                      value: d.totalBazar.toCurrencyBDT(),
                      icon: Icons.shopping_cart_outlined,
                      color: AppTheme.warning,
                    ),
                    InfoCard(
                      title: 'Total Deposit',
                      value: d.totalDeposit.toCurrencyBDT(),
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppTheme.success,
                    ),
                    _SectionHeader('Members'),
                    InfoCard(
                      title: 'Total Members',
                      value: '${d.totalMembers}',
                      icon: Icons.people_outline,
                      onTap: () => context.push(AppRoutes.members),
                    ),
                    InfoCard(
                      title: 'Pending Approval',
                      value: '${d.pendingMembers}',
                      icon: Icons.pending_actions_outlined,
                      color: d.pendingMembers > 0 ? AppTheme.warning : null,
                      onTap: () => context.push(AppRoutes.members),
                    ),
                    InfoCard(
                      title: 'Approved Members',
                      value: '${d.approvedMembers}',
                      icon: Icons.check_circle_outline,
                      color: AppTheme.success,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.cycles),
          icon: const Icon(Icons.loop),
          label: const Text('Cycles'),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey)),
      );
}

class _AdminDrawer extends StatelessWidget {
  final String adminName;
  const _AdminDrawer({required this.adminName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: AppTheme.primary),
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.admin_panel_settings,
                        color: AppTheme.primary, size: 28)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(adminName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    const Text('Admin',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          _DrawerItem(Icons.dashboard_outlined, 'Dashboard',
              () => context.go(AppRoutes.adminDashboard)),
          _DrawerItem(Icons.people_outline, 'Members',
              () => context.push(AppRoutes.members)),
          _DrawerItem(Icons.loop, 'Cycles',
              () => context.push(AppRoutes.cycles)),
          _DrawerItem(Icons.rice_bowl_outlined, 'Meals',
              () => context.push(AppRoutes.meals)),
          _DrawerItem(Icons.shopping_cart_outlined, 'Bazar',
              () => context.push(AppRoutes.bazar)),
          _DrawerItem(Icons.account_balance_wallet_outlined, 'Deposits',
              () => context.push(AppRoutes.deposits)),
          _DrawerItem(Icons.receipt_outlined, 'Khala Bill',
              () => context.push(AppRoutes.khalaBill)),
          _DrawerItem(Icons.bar_chart_outlined, 'Reports',
              () => context.push(AppRoutes.reports)),
          const Divider(),
          _DrawerItem(
            Icons.logout,
            'Logout',
            () {
              sl<AuthBloc>().add(const AuthLogoutRequested());
              context.go(AppRoutes.login);
            },
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _DrawerItem(this.icon, this.label, this.onTap, {this.color});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: color),
        title: Text(label,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600)),
        onTap: onTap,
        dense: true,
      );
}
