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
import '../../domain/entities/meal_entry_entity.dart';
import '../bloc/meals_bloc.dart';
import '../bloc/meals_event.dart';
import '../bloc/meals_state.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<CyclesBloc>()..add(const CyclesLoadRunning())),
        BlocProvider(
            create: (_) =>
                sl<MembersBloc>()..add(const MembersLoadAll())),
      ],
      child: BlocBuilder<CyclesBloc, CyclesState>(
        builder: (context, cycleState) {
          final cycleId = cycleState is CyclesLoaded
              ? cycleState.runningCycle?.id
              : null;

          return BlocProvider(
            create: (_) => sl<MealsBloc>()
              ..add(cycleId != null
                  ? MealsLoadByCycle(cycleId)
                  : const MealsLoadByCycle('')),
            child: _MealsPageBody(cycleId: cycleId),
          );
        },
      ),
    );
  }
}

class _MealsPageBody extends StatelessWidget {
  final String? cycleId;
  const _MealsPageBody({this.cycleId});

  String? get _adminId {
    final state = sl<AuthBloc>().state;
    return state is AuthAuthenticated ? state.member.id : null;
  }

  bool get _isAdmin {
    final state = sl<AuthBloc>().state;
    return state is AuthAuthenticated && state.member.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      body: BlocConsumer<MealsBloc, MealsState>(
        listener: (context, state) {
          if (state is MealsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is MealsError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is MealsLoading) return const AppLoading();
          if (state is MealsError && state is! MealsLoaded) {
            return AppError(message: (state as MealsError).message);
          }
          final meals = state is MealsLoaded
              ? state.meals
              : state is MealsActionSuccess
                  ? state.meals
                  : <MealEntryEntity>[];

          if (meals.isEmpty) {
            return const AppEmpty(
                message: 'No meals recorded yet',
                icon: Icons.rice_bowl_outlined);
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (cycleId != null) {
                context
                    .read<MealsBloc>()
                    .add(MealsLoadByCycle(cycleId!));
              }
            },
            child: ListView.builder(
              itemCount: meals.length,
              itemBuilder: (ctx, i) {
                final m = meals[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: m.mealType == MealType.full
                          ? AppTheme.primary.withOpacity(0.12)
                          : AppTheme.accent.withOpacity(0.12),
                      child: Icon(
                        m.mealType == MealType.full
                            ? Icons.rice_bowl
                            : Icons.soup_kitchen_outlined,
                        color: m.mealType == MealType.full
                            ? AppTheme.primary
                            : AppTheme.accent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      '${m.mealType.displayName} × ${m.quantity}  (${m.mealUnit} units)',
                      style:
                          const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                        DateFormat('dd MMM yyyy').format(m.mealDate)),
                    trailing: _isAdmin
                        ? IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppTheme.error, size: 20),
                            onPressed: () => context.read<MealsBloc>().add(
                                MealsDelete(
                                    mealId: m.id,
                                    cycleId: cycleId ?? '')),
                          )
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: _isAdmin && cycleId != null
          ? FloatingActionButton(
              onPressed: () =>
                  _showAddMealSheet(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddMealSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    MealType mealType = MealType.full;
    final qtyCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    DateTime mealDate = DateTime.now();
    MemberEntity? selectedMember;

    final membersState = context.read<MembersBloc>().state;
    final members = membersState is MembersLoaded ? membersState.members : <MemberEntity>[];

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
                  const Text('Add Meal',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  MemberDropdown(
                    members: members,
                    selected: selectedMember,
                    onChanged: (m) => setState(() => selectedMember = m),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Type:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('Full'),
                        selected: mealType == MealType.full,
                        onSelected: (_) =>
                            setState(() => mealType = MealType.full),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Half'),
                        selected: mealType == MealType.half,
                        onSelected: (_) =>
                            setState(() => mealType = MealType.half),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LabeledField(
                    label: 'Quantity',
                    controller: qtyCtrl,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.positiveInteger,
                  ),
                  const SizedBox(height: 12),
                  DatePickerField(
                    label: 'Meal Date',
                    initialDate: mealDate,
                    onDateSelected: (d) => mealDate = d,
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
                      context.read<MealsBloc>().add(MealsAdd(
                            adminId: _adminId!,
                            cycleId: cycleId!,
                            memberId: selectedMember!.id,
                            mealType: mealType.value,
                            quantity: int.parse(qtyCtrl.text.trim()),
                            mealDate: DateFormat('yyyy-MM-dd').format(mealDate),
                            note: noteCtrl.text.trim().isEmpty
                                ? null
                                : noteCtrl.text.trim(),
                          ));
                    },
                    child: const Text('Add Meal'),
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
