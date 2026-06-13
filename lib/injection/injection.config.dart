// GENERATED CODE - In production run: flutter pub run build_runner build
// This is a manually maintained equivalent for bootstrapping.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env/local_storage_service.dart';
import '../config/env/supabase_service.dart';
import '../core/network/network_info.dart';

// Auth
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/auth_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Members
import '../features/cycles/domain/usecases/cycles_usecase.dart';
import '../features/meals/data/repositories/meals_repository.dart';
import '../features/members/data/datasources/members_remote_datasource.dart';
import '../features/members/data/repositories/members_repository_impl.dart';
import '../features/members/domain/repositories/members_repository.dart';
import '../features/members/domain/usecases/members_usecase.dart';
import '../features/members/presentation/bloc/members_bloc.dart';

// Cycles
import '../features/cycles/data/datasources/cycles_remote_datasource.dart';
import '../features/cycles/data/repositories/cycles_repository_impl.dart';
import '../features/cycles/domain/repositories/cycles_repository.dart';
import '../features/cycles/presentation/bloc/cycles_bloc.dart';

// Meals
import '../features/meals/data/datasources/meals_remote_datasource.dart';
import '../features/meals/domain/repositories/meals_repository.dart';
import '../features/meals/domain/usecases/meals_usecases.dart';
import '../features/meals/presentation/bloc/meals_bloc.dart';

// Bazar
import '../features/bazar/data/datasources/bazar_remote_datasource.dart';
import '../features/bazar/data/repositories/bazar_repository_impl.dart';
import '../features/bazar/domain/repositories/bazar_repository.dart';
import '../features/bazar/domain/usecases/bazar_usecases.dart';
import '../features/bazar/presentation/bloc/bazar_bloc.dart';

// Deposits
import '../features/deposits/data/datasources/deposits_remote_datasource.dart';
import '../features/deposits/data/repositories/deposits_repository_impl.dart';
import '../features/deposits/domain/repositories/deposits_repository.dart';
import '../features/deposits/domain/usecases/deposits_usecases.dart';
import '../features/deposits/presentation/bloc/deposits_bloc.dart';

// Khala Bill
import '../features/khala_bill/data/datasources/khala_bill_remote_datasource.dart';
import '../features/khala_bill/data/repositories/khala_bill_repository_impl.dart';
import '../features/khala_bill/domain/repositories/khala_bill_repository.dart';
import '../features/khala_bill/domain/usecases/khala_bill_usecases.dart';
import '../features/khala_bill/presentation/bloc/khala_bill_bloc.dart';

// Notifications
import '../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../features/notifications/domain/repositories/notifications_repository.dart';
import '../features/notifications/domain/usecases/notifications_usecases.dart';
import '../features/notifications/presentation/bloc/notifications_bloc.dart';

// Dashboard
import '../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../features/dashboard/domain/usecases/dashboard_usecases.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Reports
import '../features/reports/data/datasources/reports_remote_datasource.dart';
import '../features/reports/data/repositories/reports_repository_impl.dart';
import '../features/reports/domain/repositories/reports_repository.dart';
import '../features/reports/domain/usecases/reports_usecases.dart';
import '../features/reports/presentation/bloc/reports_bloc.dart';

extension GetItInjectableX on GetIt {
  // ignore: long-method
  GetIt init() {
    // ── Core ────────────────────────────────────────────────────────────────
    registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(get<Connectivity>()));
    registerLazySingleton<SupabaseService>(() => SupabaseService());
    registerLazySingleton<LocalStorageService>(
        () => LocalStorageServiceImpl(get<SharedPreferences>()));

    // ── Auth ─────────────────────────────────────────────────────────────────
    registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(get()));
    registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(get(), get()));
    registerLazySingleton(() => LoginUseCase(get()));
    registerLazySingleton(() => RegisterUseCase(get()));
    registerLazySingleton(() => LogoutUseCase(get()));
    registerLazySingleton(() => GetCurrentMemberUseCase(get()));
    registerFactory(() => AuthBloc(get(), get(), get(), get()));

    // ── Members ───────────────────────────────────────────────────────────────
    registerLazySingleton<MembersRemoteDataSource>(
        () => MembersRemoteDataSourceImpl(get()));
    registerLazySingleton<MembersRepository>(
        () => MembersRepositoryImpl(get()));
    registerLazySingleton(() => GetAllMembersUseCase(get()));
    registerLazySingleton(() => GetMembersByStatusUseCase(get()));
    registerLazySingleton(() => ApproveMemberUseCase(get()));
    registerLazySingleton(() => RejectMemberUseCase(get()));
    registerLazySingleton(() => GetMemberByIdUseCase(get()));
    registerFactory(() => MembersBloc(get(), get(), get(), get()));

    // ── Cycles ────────────────────────────────────────────────────────────────
    registerLazySingleton<CyclesRemoteDataSource>(
        () => CyclesRemoteDataSourceImpl(get()));
    registerLazySingleton<CyclesRepository>(
        () => CyclesRepositoryImpl(get()));
    registerLazySingleton(() => GetAllCyclesUseCase(get()));
    registerLazySingleton(() => GetRunningCycleUseCase(get()));
    registerLazySingleton(() => StartNewCycleUseCase(get()));
    registerLazySingleton(() => CloseCycleUseCase(get()));
    registerFactory(() => CyclesBloc(get(), get(), get(), get()));

    // ── Meals ─────────────────────────────────────────────────────────────────
    registerLazySingleton<MealsRemoteDataSource>(
        () => MealsRemoteDataSourceImpl(get()));
    registerLazySingleton<MealsRepository>(() => MealsRepositoryImpl(get()));
    registerLazySingleton(() => GetMealsByCycleUseCase(get()));
    registerLazySingleton(() => GetMealsByMemberUseCase(get()));
    registerLazySingleton(() => AddMealUseCase(get()));
    registerLazySingleton(() => DeleteMealUseCase(get()));
    registerFactory(() => MealsBloc(get(), get(), get(), get()));

    // ── Bazar ─────────────────────────────────────────────────────────────────
    registerLazySingleton<BazarRemoteDataSource>(
        () => BazarRemoteDataSourceImpl(get()));
    registerLazySingleton<BazarRepository>(() => BazarRepositoryImpl(get()));
    registerLazySingleton(() => GetBazarByCycleUseCase(get()));
    registerLazySingleton(() => GetBazarByMemberUseCase(get()));
    registerLazySingleton(() => AddBazarUseCase(get()));
    registerLazySingleton(() => DeleteBazarUseCase(get()));
    registerFactory(() => BazarBloc(get(), get(), get(), get()));

    // ── Deposits ──────────────────────────────────────────────────────────────
    registerLazySingleton<DepositsRemoteDataSource>(
        () => DepositsRemoteDataSourceImpl(get()));
    registerLazySingleton<DepositsRepository>(
        () => DepositsRepositoryImpl(get()));
    registerLazySingleton(() => GetDepositsByCycleUseCase(get()));
    registerLazySingleton(() => GetDepositsByMemberUseCase(get()));
    registerLazySingleton(() => AddDepositUseCase(get()));
    registerLazySingleton(() => DeleteDepositUseCase(get()));
    registerFactory(() => DepositsBloc(get(), get(), get(), get()));

    // ── Khala Bill ────────────────────────────────────────────────────────────
    registerLazySingleton<KhalaBillRemoteDataSource>(
        () => KhalaBillRemoteDataSourceImpl(get()));
    registerLazySingleton<KhalaBillRepository>(
        () => KhalaBillRepositoryImpl(get()));
    registerLazySingleton(() => GetKhalaBillsByCycleUseCase(get()));
    registerLazySingleton(() => GetKhalaBillsByMemberUseCase(get()));
    registerLazySingleton(() => AddKhalaBillUseCase(get()));
    registerLazySingleton(() => DeleteKhalaBillUseCase(get()));
    registerFactory(() => KhalaBillBloc(get(), get(), get(), get()));

    // ── Notifications ─────────────────────────────────────────────────────────
    registerLazySingleton<NotificationsRemoteDataSource>(
        () => NotificationsRemoteDataSourceImpl(get()));
    registerLazySingleton<NotificationsRepository>(
        () => NotificationsRepositoryImpl(get()));
    registerLazySingleton(() => GetNotificationsUseCase(get()));
    registerLazySingleton(() => MarkNotificationReadUseCase(get()));
    registerLazySingleton(() => MarkAllNotificationsReadUseCase(get()));
    registerFactory(() => NotificationsBloc(get(), get(), get()));

    // ── Dashboard ─────────────────────────────────────────────────────────────
    registerLazySingleton<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSourceImpl(get()));
    registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(get()));
    registerLazySingleton(() => GetAdminDashboardUseCase(get()));
    registerLazySingleton(() => GetMemberDashboardUseCase(get()));
    registerFactory(() => DashboardBloc(get(), get()));

    // ── Reports ───────────────────────────────────────────────────────────────
    registerLazySingleton<ReportsRemoteDataSource>(
        () => ReportsRemoteDataSourceImpl(get()));
    registerLazySingleton<ReportsRepository>(
        () => ReportsRepositoryImpl(get()));
    registerLazySingleton(() => GetCycleSummariesUseCase(get()));
    registerLazySingleton(() => GetMemberBalanceViewUseCase(get()));
    registerLazySingleton(() => GetAllMemberBalancesUseCase(get()));
    registerFactory(() => ReportsBloc(get(), get(), get()));

    return this;
  }
}
