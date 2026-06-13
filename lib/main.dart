import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'config/env/env_config.dart';
import 'config/env/local_storage_service.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/domain/entities/member_entity.dart';
import 'features/auth/domain/usecases/auth_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );

    debugPrint('✅ Supabase Connected');
    debugPrint('URL: ${EnvConfig.supabaseUrl}');

    await configureDependencies();

    debugPrint('✅ DI Initialized');

    debugPrint(
      'LoginUseCase registered: ${sl.isRegistered<LoginUseCase>()}',
    );

    debugPrint(
      'AuthBloc registered: ${sl.isRegistered<AuthBloc>()}',
    );

    runApp(const MealManagerApp());
  } catch (e, st) {
    debugPrint('❌ MAIN ERROR: $e');
    debugPrint(st.toString());
  }
}

class MealManagerApp extends StatefulWidget {
  const MealManagerApp({super.key});

  @override
  State<MealManagerApp> createState() => _MealManagerAppState();
}

class _MealManagerAppState extends State<MealManagerApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router; // 👈 রাউটার ভ্যারিয়েবল এখানে ডিক্লেয়ার করুন

  @override
  void initState() {
    super.initState();

    debugPrint('🚀 Creating AuthBloc');
    _authBloc = sl<AuthBloc>();

    // 👈 একবারই রাউটার তৈরি হবে এবং পুরো অ্যাপে এটিই পাস হবে
    _router = createRouter(_authBloc);

    _authBloc.add(const AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'Meal Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router, // 👈 এখানে স্টেবল করা _router পাস হলো
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}