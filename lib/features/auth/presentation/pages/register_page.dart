import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../injection/injection.dart';
import '../../../../shared/validators/from_validator.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _thanaCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    _districtCtrl.dispose();
    _thanaCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(
          fullName: _nameCtrl.text.trim(),
          mobileNumber: _mobileCtrl.text.trim(),
          password: _passwordCtrl.text,
          district: _districtCtrl.text.trim().isEmpty
              ? null
              : _districtCtrl.text.trim(),
          thana: _thanaCtrl.text.trim().isEmpty
              ? null
              : _thanaCtrl.text.trim(),
          address: _addressCtrl.text.trim().isEmpty
              ? null
              : _addressCtrl.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('Registration Submitted'),
                content: const Text(
                    'Your account is pending admin approval. You will be notified once approved.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Account')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledField(
                      label: 'Full Name *',
                      hint: 'Enter your full name',
                      controller: _nameCtrl,
                      validator: FormValidators.required,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 14),
                    LabeledField(
                      label: 'Mobile Number *',
                      hint: '01XXXXXXXXX',
                      controller: _mobileCtrl,
                      keyboardType: TextInputType.phone,
                      validator: FormValidators.mobileNumber,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    const SizedBox(height: 14),
                    LabeledField(
                      label: 'Password *',
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      validator: FormValidators.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 14),
                    LabeledField(
                      label: 'District',
                      controller: _districtCtrl,
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    const SizedBox(height: 14),
                    LabeledField(
                      label: 'Thana',
                      controller: _thanaCtrl,
                      prefixIcon: const Icon(Icons.map_outlined),
                    ),
                    const SizedBox(height: 14),
                    LabeledField(
                      label: 'Address',
                      controller: _addressCtrl,
                      maxLines: 3,
                      prefixIcon: const Icon(Icons.home_outlined),
                    ),
                    const SizedBox(height: 28),
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () => _submit(context),
                        child: const Text('Register'),
                      ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Already have an account? Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
