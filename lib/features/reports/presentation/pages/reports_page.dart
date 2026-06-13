import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/balance_chip.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../cycles/presentation/bloc/cycles_bloc.dart';
import '../../../cycles/presentation/bloc/cycles_event.dart';
import '../../../cycles/presentation/bloc/cycles_state.dart';
import '../../../dashboard/domain/entities/admin_dashbord_entity.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<CyclesBloc>()..add(const CyclesLoadAll())),
        BlocProvider(create: (_) => sl<ReportsBloc>()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Reports'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Balance View'),
                Tab(text: 'Cycle Summary'),
              ],
              labelColor: Colors.white,
              indicatorColor: Colors.white,
            ),
          ),
          body: BlocBuilder<CyclesBloc, CyclesState>(
            builder: (context, cycleState) {
              final cycles = cycleState is CyclesLoaded ? cycleState.cycles : [];
              final runningId = cycleState is CyclesLoaded
                  ? cycleState.runningCycle?.id
                  : null;

              return TabBarView(
                children: [
                  _BalanceTab(
                    cycles: cycles
                        .map((c) => MapEntry<String, String>(c.id, c.cycleCode))
                        .toList(),
                    initialCycleId: runningId,
                  ),
                  _SummaryTab(
                    cycles: cycles
                        .map((c) => MapEntry<String, String>(c.id, c.cycleCode))
                        .toList(),
                    initialCycleId: runningId,
                  ),
                ],
              );
              },
          ),
        ),
      ),
    );
  }
}

class _BalanceTab extends StatefulWidget {
  final List<MapEntry<String, String>> cycles;
  final String? initialCycleId;
  const _BalanceTab({required this.cycles, this.initialCycleId});

  @override
  State<_BalanceTab> createState() => _BalanceTabState();
}

class _BalanceTabState extends State<_BalanceTab> {
  String? _selectedCycleId;

  @override
  void initState() {
    super.initState();
    _selectedCycleId = widget.initialCycleId;
    if (_selectedCycleId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<ReportsBloc>()
            .add(ReportsLoadMemberBalance(_selectedCycleId!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.cycles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: _selectedCycleId,
              decoration: const InputDecoration(
                  labelText: 'Select Cycle',
                  prefixIcon: Icon(Icons.loop)),
              items: widget.cycles
                  .map((e) => DropdownMenuItem(
                      value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (id) {
                setState(() => _selectedCycleId = id);
                if (id != null) {
                  context
                      .read<ReportsBloc>()
                      .add(ReportsLoadMemberBalance(id));
                }
              },
            ),
          ),
        Expanded(
          child: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoading) return const AppLoading();
              if (state is ReportsError) {
                return AppError(message: state.message);
              }
              if (state is ReportsMemberBalanceLoaded) {
                if (state.balances.isEmpty) {
                  return const AppEmpty(
                      message: 'No balance data for this cycle');
                }
                return _BalanceList(balances: state.balances);
              }
              return const AppEmpty(
                  message: 'Select a cycle to view balances',
                  icon: Icons.bar_chart_outlined);
            },
          ),
        ),
      ],
    );
  }
}

class _BalanceList extends StatelessWidget {
  final List<MemberBalanceEntity> balances;
  const _BalanceList({required this.balances});

  @override
  Widget build(BuildContext context) {
    // Summary row
    final totalDeposit =
        balances.fold<double>(0, (s, b) => s + b.totalDeposit);
    final totalMealCost =
        balances.fold<double>(0, (s, b) => s + b.mealCost);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                  child: _SumItem('Total Deposit',
                      totalDeposit.toCurrencyBDT(), AppTheme.success)),
              const VerticalDivider(),
              Expanded(
                  child: _SumItem('Total Meal Cost',
                      totalMealCost.toCurrencyBDT(), AppTheme.error)),
              const VerticalDivider(),
              Expanded(
                  child: _SumItem(
                      'Members',
                      '${balances.length}',
                      AppTheme.primary)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: balances.length,
            itemBuilder: (ctx, i) {
              final b = balances[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                AppTheme.primary.withOpacity(0.1),
                            child: Text(
                              b.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(b.fullName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                                Text(b.mobileNumber,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                          BalanceChip(balance: b.currentBalance),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _MiniStat(
                              'Full', '${b.totalFullMeal}'),
                          _MiniStat(
                              'Half', '${b.totalHalfMeal}'),
                          _MiniStat('Units',
                              b.totalMealUnit.toDecimal()),
                          _MiniStat('Rate',
                              b.mealRate.toCurrencyBDT()),
                          _MiniStat('Deposit',
                              b.totalDeposit.toCurrencyBDT()),
                          _MiniStat('Cost',
                              b.mealCost.toCurrencyBDT()),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryTab extends StatefulWidget {
  final List<MapEntry<String, String>> cycles;
  final String? initialCycleId;
  const _SummaryTab({required this.cycles, this.initialCycleId});

  @override
  State<_SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<_SummaryTab> {
  String? _selectedCycleId;

  @override
  void initState() {
    super.initState();
    _selectedCycleId = widget.initialCycleId;
    if (_selectedCycleId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<ReportsBloc>()
            .add(ReportsLoadCycleSummary(_selectedCycleId!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.cycles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: _selectedCycleId,
              decoration: const InputDecoration(
                  labelText: 'Select Cycle',
                  prefixIcon: Icon(Icons.loop)),
              items: widget.cycles
                  .map((e) => DropdownMenuItem(
                      value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (id) {
                setState(() => _selectedCycleId = id);
                if (id != null) {
                  context
                      .read<ReportsBloc>()
                      .add(ReportsLoadCycleSummary(id));
                }
              },
            ),
          ),
        Expanded(
          child: BlocBuilder<ReportsBloc, ReportsState>(
            builder: (context, state) {
              if (state is ReportsLoading) return const AppLoading();
              if (state is ReportsError) {
                return AppError(message: state.message);
              }
              if (state is ReportsCycleSummaryLoaded) {
                if (state.summaries.isEmpty) {
                  return const AppEmpty(
                      message: 'No summaries — cycle may still be running');
                }
                return ListView.builder(
                  itemCount: state.summaries.length,
                  itemBuilder: (ctx, i) {
                    final s = state.summaries[i];
                    return Card(
                      child: ListTile(
                        title: Text('Member: ${s.memberId}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        subtitle: Text(
                          'Units: ${s.totalMealUnit}  '
                          'Rate: ${s.mealRate.toCurrencyBDT()}  '
                          'Cost: ${s.mealCost.toCurrencyBDT()}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: BalanceChip(balance: s.currentBalance),
                      ),
                    );
                  },
                );
              }
              return const AppEmpty(
                  message: 'Select a closed cycle to view summary',
                  icon: Icons.summarize_outlined);
            },
          ),
        ),
      ],
    );
  }
}

class _SumItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SumItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: color)),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      );
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 12)),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      );
}
