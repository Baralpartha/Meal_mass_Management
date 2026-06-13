import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/extensions/number_extentation.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/validators/from_validator.dart';
import '../../../../shared/widgets/app_empty.dart';
import '../../../../shared/widgets/app_error.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/date_picker_field.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../../../../shared/widgets/member_dropdown.dart';
import '../../../auth/domain/entities/member_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../cycles/presentation/bloc/cycles_bloc.dart';
import '../../../cycles/presentation/bloc/cycles_event.dart';
import '../../../cycles/presentation/bloc/cycles_state.dart';
import '../../../members/presentation/bloc/members_bloc.dart';
import '../../../members/presentation/bloc/members_event.dart';
import '../../../members/presentation/bloc/members_state.dart';
import '../../domain/entities/deposit_entry_entity.dart';
import '../bloc/deposits_bloc.dart';
import '../bloc/deposits_event.dart';
import '../bloc/deposits_state.dart';

class DepositsPage extends StatelessWidget {
  const DepositsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<CyclesBloc>()..add(const CyclesLoadRunning())),
        BlocProvider(
            create: (_) => sl<MembersBloc>()..add(const MembersLoadAll())),
      ],
      child: BlocBuilder<CyclesBloc, CyclesState>(
        builder: (context, cycleState) {
          final cycleId =
              cycleState is CyclesLoaded ? cycleState.runningCycle?.id : null;
          return BlocProvider(
            create: (_) => sl<DepositsBloc>()
              ..add(DepositsLoadByCycle(cycleId ?? '')),
            child: _DepositsBody(cycleId: cycleId),
          );
        },
      ),
    );
  }
}

class _DepositsBody extends StatelessWidget {
  final String? cycleId;
  const _DepositsBody({this.cycleId});

  bool get _isAdmin {
    final s = sl<AuthBloc>().state;
    return s is AuthAuthenticated && s.member.isAdmin;
  }

  String? get _adminId {
    final s = sl<AuthBloc>().state;
    return s is AuthAuthenticated ? s.member.id : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deposits')),
      body: BlocConsumer<DepositsBloc, DepositsState>(
        listener: (context, state) {
          if (state is DepositsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is DepositsError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is DepositsLoading) return const AppLoading();
          if (state is DepositsError && state is! DepositsLoaded) {
            return AppError(message: (state as DepositsError).message);
          }
          final deposits = state is DepositsLoaded
              ? state.deposits
              : state is DepositsActionSuccess
                  ? state.deposits
                  : <DepositEntryEntity>[];

          if (deposits.isEmpty) {
            return const AppEmpty(
                message: 'No deposits yet',
                icon: Icons.account_balance_wallet_outlined);
          }

          final total =
              deposits.fold<double>(0, (s, d) => s + d.amount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Deposits',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(total.toCurrencyBDT(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.success,
                            fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: deposits.length,
                  itemBuilder: (ctx, i) {
                    final d = deposits[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F5E9),
                          child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppTheme.success),
                        ),
                        title: Text(d.amount.toCurrencyBDT(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppTheme.success)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('dd MMM yyyy')
                                .format(d.depositDate)),
                            if (d.note != null)
                              Text(d.note!,
                                  style:
                                      const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: _isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppTheme.error, size: 20),
                                onPressed: () => context
                                    .read<DepositsBloc>()
                                    .add(DepositsDelete(
                                        depositId: d.id,
                                        cycleId: cycleId ?? '')),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _isAdmin && cycleId != null
          ? FloatingActionButton(
              onPressed: () => _showAddSheet(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    DateTime depositDate = DateTime.now();
    MemberEntity? selectedMember;

    final membersState = context.read<MembersBloc>().state;
    final members =
        membersState is MembersLoaded ? membersState.members : <MemberEntity>[];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Deposit',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  MemberDropdown(
                    members: members,
                    selected: selectedMember,
                    onChanged: (m) => setState(() => selectedMember = m),
                  ),
                  const SizedBox(height: 12),
                  LabeledField(
                    label: 'Amount *',
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.positiveAmount,
                  ),
                  const SizedBox(height: 12),
                  DatePickerField(
                    label: 'Deposit Date',
                    initialDate: depositDate,
                    onDateSelected: (d) => depositDate = d,
                  ),
                  const SizedBox(height: 12),
                  LabeledField(
                    label: 'Note (optional)',
                    controller: noteCtrl,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      if (selectedMember == null) return;
                      Navigator.pop(ctx);
                      context.read<DepositsBloc>().add(DepositsAdd(
                            adminId: _adminId!,
                            cycleId: cycleId!,
                            memberId: selectedMember!.id,
                            amount: double.parse(amountCtrl.text.trim()),
                            depositDate:
                                DateFormat('yyyy-MM-dd').format(depositDate),
                            note: noteCtrl.text.trim().isEmpty
                                ? null
                                : noteCtrl.text.trim(),
                          ));
                    },
                    child: const Text('Add Deposit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
