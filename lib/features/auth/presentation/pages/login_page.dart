import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../shared/validators/from_validator.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    // গ্লোবাল AuthBloc-এ ইভেন্ট পাঠানো হচ্ছে
    context.read<AuthBloc>().add(AuthLoginRequested(
      mobileNumber: _mobileCtrl.text.trim(),
      password: _passwordCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // 👈 এখান থেকে নতুন করে BlocProvider তৈরি করার লজিকটি ফেলে দেওয়া হয়েছে
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.member.isAdmin) {
            context.go(AppRoutes.adminDashboard);
          } else {
            context.go(AppRoutes.memberDashboard);
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppTheme.primary,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 48),
                const Icon(Icons.restaurant_menu, size: 72, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Meal Manager',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage your meal cycle efficiently',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            const Text(
                              'Login to your account',
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 28),
                            LabeledField(
                              label: 'Mobile Number',
                              hint: '01XXXXXXXXX',
                              controller: _mobileCtrl,
                              keyboardType: TextInputType.phone,
                              validator: FormValidators.mobileNumber,
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                            const SizedBox(height: 16),
                            LabeledField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              validator: FormValidators.password,
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            const SizedBox(height: 28),
                            if (state is AuthLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                ),
                                onPressed: () => _submit(context),
                                child: const Text('Login'),
                              ),
                            const SizedBox(height: 16),
                            Center(
                              child: TextButton(
                                onPressed: () => context.push(AppRoutes.register),
                                child: const Text("Don't have an account? Register"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}