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
import '../../domain/entities/bazar_entry_entity.dart';
import '../bloc/bazar_bloc.dart';
import '../bloc/bazar_event.dart';
import '../bloc/bazar_state.dart';

class BazarPage extends StatelessWidget {
  const BazarPage({super.key});

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
            create: (_) => sl<BazarBloc>()
              ..add(BazarLoadByCycle(cycleId ?? '')),
            child: _BazarBody(cycleId: cycleId),
          );
        },
      ),
    );
  }
}

class _BazarBody extends StatelessWidget {
  final String? cycleId;
  const _BazarBody({this.cycleId});

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
      appBar: AppBar(title: const Text('Bazar')),
      body: BlocConsumer<BazarBloc, BazarState>(
        listener: (context, state) {
          if (state is BazarActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is BazarError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is BazarLoading) return const AppLoading();
          if (state is BazarError && state is! BazarLoaded) {
            return AppError(message: (state as BazarError).message);
          }
          final entries = state is BazarLoaded
              ? state.entries
              : state is BazarActionSuccess
                  ? state.entries
                  : <BazarEntryEntity>[];

          if (entries.isEmpty) {
            return const AppEmpty(
                message: 'No bazar entries yet',
                icon: Icons.shopping_cart_outlined);
          }

          final total = entries.fold<double>(0, (s, e) => s + e.amount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.warning.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Bazar',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(total.toCurrencyBDT(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.warning,
                            fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (ctx, i) {
                    final e = entries[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFF3E0),
                          child: Icon(Icons.shopping_bag_outlined,
                              color: AppTheme.warning),
                        ),
                        title: Text(e.description,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (e.quantity != null)
                              Text(e.quantity!,
                                  style: const TextStyle(fontSize: 12)),
                            Text(DateFormat('dd MMM yyyy')
                                .format(e.bazarDate)),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(e.amount.toCurrencyBDT(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                            if (_isAdmin)
                              GestureDetector(
                                onTap: () =>
                                    context.read<BazarBloc>().add(BazarDelete(
                                          bazarId: e.id,
                                          cycleId: cycleId ?? '',
                                        )),
                                child: const Icon(Icons.delete_outline,
                                    color: AppTheme.error, size: 18),
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
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    DateTime bazarDate = DateTime.now();
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
                  const Text('Add Bazar Entry',
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
                    label: 'Description *',
                    controller: descCtrl,
                    validator: FormValidators.required,
                  ),
                  const SizedBox(height: 12),
                  LabeledField(
                    label: 'Amount *',
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.positiveAmount,
                  ),
                  const SizedBox(height: 12),
                  LabeledField(
                    label: 'Quantity (optional)',
                    controller: qtyCtrl,
                  ),
                  const SizedBox(height: 12),
                  DatePickerField(
                    label: 'Bazar Date',
                    initialDate: bazarDate,
                    onDateSelected: (d) => bazarDate = d,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      if (selectedMember == null) return;
                      Navigator.pop(ctx);
                      context.read<BazarBloc>().add(BazarAdd(
                            adminId: _adminId!,
                            cycleId: cycleId!,
                            memberId: selectedMember!.id,
                            description: descCtrl.text.trim(),
                            amount: double.parse(amountCtrl.text.trim()),
                            quantity: qtyCtrl.text.trim().isEmpty
                                ? null
                                : qtyCtrl.text.trim(),
                            bazarDate:
                                DateFormat('yyyy-MM-dd').format(bazarDate),
                          ));
                    },
                    child: const Text('Add Bazar'),
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
