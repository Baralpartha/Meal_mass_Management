import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/balance_chip.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../../dashboard/presentation/bloc/dashboard_state.dart';


class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>();
    final member = (authBloc.state is AuthAuthenticated)
        ? (authBloc.state as AuthAuthenticated).member
        : null;

    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
        ..add(DashboardLoadMember(member?.id ?? '')),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                sl<AuthBloc>().add(const AuthLogoutRequested());
                context.go(AppRoutes.login);
              },
            ),
          ],
        ),
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const AppLoading(message: 'Loading...');
            }
            if (state is DashboardError) {
              return AppError(
                message: state.message,
                onRetry: () => context
                    .read<DashboardBloc>()
                    .add(DashboardLoadMember(member?.id ?? '')),
              );
            }
            if (state is MemberDashboardLoaded) {
              if (state.balances.isEmpty) {
                return const AppEmpty(
                    message: 'No active cycle data available');
              }
              final b = state.balances.first;
              return RefreshIndicator(
                onRefresh: () async => context
                    .read<DashboardBloc>()
                    .add(DashboardLoadMember(member?.id ?? '')),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Welcome
                    Text('Hello, ${b.fullName} 👋',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Cycle: ${b.cycleCode}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 20),
                    // Balance card
                    Card(
                      color: b.currentBalance >= 0
                          ? AppTheme.advance.withOpacity(0.08)
                          : AppTheme.due.withOpacity(0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text('Current Balance',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 8),
                            BalanceChip(balance: b.currentBalance),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: [
                        _StatTile('Full Meals', '${b.totalFullMeal}',
                            Icons.rice_bowl),
                        _StatTile('Half Meals', '${b.totalHalfMeal}',
                            Icons.soup_kitchen_outlined),
                        _StatTile('Meal Units',
                            b.totalMealUnit.toDecimal(), Icons.calculate_outlined),
                        _StatTile('Meal Rate',
                            b.mealRate.toCurrencyBDT(), Icons.price_change_outlined),
                        _StatTile('Total Deposit',
                            b.totalDeposit.toCurrencyBDT(),
                            Icons.account_balance_wallet_outlined),
                        _StatTile('Meal Cost',
                            b.mealCost.toCurrencyBDT(), Icons.receipt_outlined),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Quick links
                    const Text('Quick Access',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _QuickChip('My Meals', Icons.rice_bowl_outlined,
                            () => context.push(AppRoutes.meals)),
                        _QuickChip('Deposits',
                            Icons.account_balance_wallet_outlined,
                            () => context.push(AppRoutes.deposits)),
                        _QuickChip('Bazar', Icons.shopping_cart_outlined,
                            () => context.push(AppRoutes.bazar)),
                        _QuickChip('Khala Bill', Icons.receipt_outlined,
                            () => context.push(AppRoutes.khalaBill)),
                        _QuickChip('Reports', Icons.bar_chart_outlined,
                            () => context.push(AppRoutes.reports)),
                      ],
                    ),
                  ],
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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatTile(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 18, color: Colors.grey),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 15)),
            Text(label,
                style:
                    const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      );
}

class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _QuickChip(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) => ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
        onPressed: onTap,
      );
}
