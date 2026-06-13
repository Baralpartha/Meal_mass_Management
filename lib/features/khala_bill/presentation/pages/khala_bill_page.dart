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
import '../../domain/entities/khala_bill_entity.dart';
import '../bloc/khala_bill_bloc.dart';
import '../bloc/khala_bill_event.dart';
import '../bloc/khala_bill_state.dart';

class KhalaBillPage extends StatelessWidget {
  const KhalaBillPage({super.key});

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
            create: (_) => sl<KhalaBillBloc>()
              ..add(KhalaBillLoadByCycle(cycleId ?? '')),
            child: _KhalaBillBody(cycleId: cycleId),
          );
        },
      ),
    );
  }
}

class _KhalaBillBody extends StatelessWidget {
  final String? cycleId;
  const _KhalaBillBody({this.cycleId});

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
      appBar: AppBar(title: const Text('Khala Bill')),
      body: BlocConsumer<KhalaBillBloc, KhalaBillState>(
        listener: (context, state) {
          if (state is KhalaBillActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is KhalaBillError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is KhalaBillLoading) return const AppLoading();
          if (state is KhalaBillError && state is! KhalaBillLoaded) {
            return AppError(message: (state as KhalaBillError).message);
          }
          final bills = state is KhalaBillLoaded
              ? state.bills
              : state is KhalaBillActionSuccess
                  ? state.bills
                  : <KhalaBillEntity>[];

          if (bills.isEmpty) {
            return const AppEmpty(
                message: 'No khala bills yet',
                icon: Icons.receipt_long_outlined);
          }

          final total = bills.fold<double>(0, (s, b) => s + b.amount);

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Khala Bill',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text(total.toCurrencyBDT(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.purple,
                            fontSize: 16)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (ctx, i) {
                    final b = bills[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFF3E5F5),
                          child: Icon(Icons.receipt_outlined,
                              color: Colors.purple),
                        ),
                        title: Text(b.amount.toCurrencyBDT(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.purple)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat('dd MMM yyyy').format(b.billDate)),
                            if (b.note != null)
                              Text(b.note!,
                                  style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: _isAdmin
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppTheme.error, size: 20),
                                onPressed: () =>
                                    context.read<KhalaBillBloc>().add(
                                          KhalaBillDelete(
                                              billId: b.id,
                                              cycleId: cycleId ?? ''),
                                        ),
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
    DateTime billDate = DateTime.now();
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
                  const Text('Add Khala Bill',
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
                    label: 'Bill Date',
                    initialDate: billDate,
                    onDateSelected: (d) => billDate = d,
                  ),
                  const SizedBox(height: 12),
                  LabeledField(label: 'Note (optional)', controller: noteCtrl),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      if (selectedMember == null) return;
                      Navigator.pop(ctx);
                      context.read<KhalaBillBloc>().add(KhalaBillAdd(
                            adminId: _adminId!,
                            cycleId: cycleId!,
                            memberId: selectedMember!.id,
                            amount: double.parse(amountCtrl.text.trim()),
                            note: noteCtrl.text.trim().isEmpty
                                ? null
                                : noteCtrl.text.trim(),
                            billDate:
                                DateFormat('yyyy-MM-dd').format(billDate),
                          ));
                    },
                    child: const Text('Add Khala Bill'),
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
