import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/member_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../../features/members/presentation/pages/member_dashboard_page.dart';
import '../../features/members/presentation/pages/members_list_page.dart';
import '../../features/members/presentation/pages/member_detail_page.dart';
import '../../features/cycles/presentation/pages/cycles_page.dart';
import '../../features/meals/presentation/pages/meals_page.dart';
import '../../features/bazar/presentation/pages/bazar_page.dart';
import '../../features/deposits/presentation/pages/deposits_page.dart';
import '../../features/khala_bill/presentation/pages/khala_bill_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRoutes {
  AppRoutes._();
  static const String login = '/login';
  static const String register = '/register';
  static const String adminDashboard = '/admin-dashboard';
  static const String memberDashboard = '/member-dashboard';
  static const String members = '/members';
  static const String memberDetail = '/members/:id';
  static const String cycles = '/cycles';
  static const String meals = '/meals';
  static const String bazar = '/bazar';
  static const String deposits = '/deposits';
  static const String khalaBill = '/khala-bill';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String settings = '/settings';
}

// 👈 AuthBloc-কে রিসিভ করার জন্য রাউটার বিল্ডার মডিফাই করা হলো
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    // 👈 এটি লগইন বাটন প্রেস করার সাথে সাথে রাউটারকে ট্রিগার করবে
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final loggedIn = authState is AuthAuthenticated;

      final goingToLogin = state.matchedLocation == AppRoutes.login;
      final goingToRegister = state.matchedLocation == AppRoutes.register;

      // ইউজার যদি লগইন না থাকে এবং লগইন/রেজিস্ট্রেশন বাদে অন্য কোথাও যেতে চায়, তবে লগইনে পাঠান
      if (!loggedIn && !goingToLogin && !goingToRegister) {
        return AppRoutes.login;
      }

      // ইউজার যদি অলরেডি লগইন থাকে এবং লগইন/রেজিস্ট্রেশন স্ক্রিনে আসতে চায়, তবে ড্যাশবোর্ডে রিডাইরেক্ট করুন
      if (loggedIn && (goingToLogin || goingToRegister)) {
        final currentMember = authState.member;
        return currentMember.isAdmin
            ? AppRoutes.adminDashboard
            : AppRoutes.memberDashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (_, __) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.memberDashboard,
        builder: (_, __) => const MemberDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.members,
        builder: (_, __) => const MembersListPage(),
      ),
      GoRoute(
        path: AppRoutes.memberDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MemberDetailPage(memberId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.cycles,
        builder: (_, __) => const CyclesPage(),
      ),
      GoRoute(
        path: AppRoutes.meals,
        builder: (_, __) => const MealsPage(),
      ),
      GoRoute(
        path: AppRoutes.bazar,
        builder: (_, __) => const BazarPage(),
      ),
      GoRoute(
        path: AppRoutes.deposits,
        builder: (_, __) => const DepositsPage(),
      ),
      GoRoute(
        path: AppRoutes.khalaBill,
        builder: (_, __) => const KhalaBillPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (_, __) => const ReportsPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}

// 💡 Bloc Stream-কে GoRouter এর উপযোগী করার জন্য এই হেল্পার ক্লাসটি যোগ করুন
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}