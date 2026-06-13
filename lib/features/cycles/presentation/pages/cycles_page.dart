import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/validators/from_validator.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/cycles_bloc.dart';
import '../bloc/cycles_event.dart';
import '../bloc/cycles_state.dart';

class CyclesPage extends StatelessWidget {
  const CyclesPage({super.key});

  String? get _adminId {
    final state = sl<AuthBloc>().state;
    return state is AuthAuthenticated ? state.member.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CyclesBloc>()..add(const CyclesLoadAll()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cycles')),
        body: BlocConsumer<CyclesBloc, CyclesState>(
          listener: (context, state) {
            if (state is CyclesActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.success,
                behavior: SnackBarBehavior.floating,
              ));
              context.read<CyclesBloc>().add(const CyclesLoadAll());
            } else if (state is CyclesError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.error,
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          builder: (context, state) {
            if (state is CyclesLoading) return const AppLoading();
            if (state is CyclesError) {
              return AppError(
                  message: state.message,
                  onRetry: () => context
                      .read<CyclesBloc>()
                      .add(const CyclesLoadAll()));
            }
            if (state is CyclesLoaded) {
              return Column(
                children: [
                  if (state.runningCycle != null)
                    _RunningCycleBanner(
                      code: state.runningCycle!.cycleCode,
                      adminId: _adminId,
                      cycleId: state.runningCycle!.id,
                    ),
                  Expanded(
                    child: state.cycles.isEmpty
                        ? const AppEmpty(message: 'No cycles yet')
                        : RefreshIndicator(
                            onRefresh: () async => context
                                .read<CyclesBloc>()
                                .add(const CyclesLoadAll()),
                            child: ListView.builder(
                              itemCount: state.cycles.length,
                              itemBuilder: (ctx, i) {
                                final c = state.cycles[i];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: c.isRunning
                                          ? AppTheme.success.withOpacity(0.15)
                                          : Colors.grey.shade100,
                                      child: Icon(
                                        c.isRunning
                                            ? Icons.play_circle_outline
                                            : Icons.check_circle_outline,
                                        color: c.isRunning
                                            ? AppTheme.success
                                            : Colors.grey,
                                      ),
                                    ),
                                    title: Text(c.cycleCode,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text(
                                      'Start: ${DateFormat('dd MMM yyyy').format(c.startDate)}'
                                      '${c.endDate != null ? '  End: ${DateFormat('dd MMM yyyy').format(c.endDate!)}' : ''}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          c.status.name.toUpperCase(),
                                          style: TextStyle(
                                              color: c.isRunning
                                                  ? AppTheme.success
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 11),
                                        ),
                                        Text(
                                            'Rate: ৳${c.mealRate.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(builder: (ctx) {
          return FloatingActionButton.extended(
            onPressed: () => _showStartCycleDialog(ctx),
            icon: const Icon(Icons.add),
            label: const Text('New Cycle'),
          );
        }),
      ),
    );
  }

  void _showStartCycleDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController();
    DateTime startDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(sheetCtx).viewInsets.bottom + 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start New Cycle',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              LabeledField(
                label: 'Cycle Code',
                hint: 'e.g. CYCLE-002',
                controller: codeCtrl,
                validator: FormValidators.required,
              ),
              const SizedBox(height: 12),
              DatePickerField(
                label: 'Start Date',
                initialDate: startDate,
                onDateSelected: (d) => startDate = d,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  Navigator.pop(sheetCtx);
                  context.read<CyclesBloc>().add(CyclesStart(
                        adminId: _adminId!,
                        cycleCode: codeCtrl.text.trim(),
                        startDate: DateFormat('yyyy-MM-dd').format(startDate),
                      ));
                },
                child: const Text('Start Cycle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RunningCycleBanner extends StatelessWidget {
  final String code;
  final String? adminId;
  final String cycleId;
  const _RunningCycleBanner(
      {required this.code, this.adminId, required this.cycleId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.1),
        border: Border.all(color: AppTheme.success.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_filled, color: AppTheme.success),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Running Cycle',
                    style: TextStyle(
                        color: AppTheme.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
                Text(code,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          if (adminId != null)
            TextButton(
              onPressed: () => _confirmClose(context),
              child: const Text('Close',
                  style: TextStyle(color: AppTheme.error)),
            ),
        ],
      ),
    );
  }

  void _confirmClose(BuildContext context) {
    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Close Cycle?'),
        content: const Text(
            'This will calculate final balances and carry them forward. This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(dCtx);
              context.read<CyclesBloc>().add(CyclesClose(
                    adminId: adminId!,
                    cycleId: cycleId,
                    endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  ));
            },
            child: const Text('Close Cycle',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
