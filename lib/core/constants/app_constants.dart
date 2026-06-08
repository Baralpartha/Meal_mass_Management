class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Meal Manager';
  static const String appVersion = '1.0.0';

  // Supabase Tables
  static const String membersTable = 'members';
  static const String cyclesTable = 'cycles';
  static const String mealEntriesTable = 'meal_entries';
  static const String bazarEntriesTable = 'bazar_entries';
  static const String depositEntriesTable = 'deposit_entries';
  static const String khalaBillsTable = 'khala_bills';
  static const String notificationsTable = 'notifications';
  static const String cycleMemberSummariesTable = 'cycle_member_summaries';

  // Supabase Views
  static const String cycleReportView = 'cycle_report_view';
  static const String memberCycleBalanceView = 'member_cycle_balance_view';

  // Supabase Functions
  static const String adminApproveFunction = 'admin_approve_member';
  static const String adminRejectFunction = 'admin_reject_member';
  static const String adminAddMealFunction = 'admin_add_meal';
  static const String adminAddBazarFunction = 'admin_add_bazar';
  static const String adminAddDepositFunction = 'admin_add_deposit';
  static const String adminAddKhalaBillFunction = 'admin_add_khala_bill';
  static const String startNewCycleFunction = 'start_new_cycle';
  static const String closeCycleFunction = 'close_cycle';
  static const String getAdminDashboardFunction = 'get_admin_dashboard';
  static const String getMemberDashboardFunction = 'get_member_dashboard';
  static const String getMemberMealsFunction = 'get_member_meals';
  static const String getMemberDepositsFunction = 'get_member_deposits';
  static const String getMemberBazarsFunction = 'get_member_bazars';
  static const String getMemberKhalaBillsFunction = 'get_member_khala_bills';
  static const String getMemberNotificationsFunction = 'get_member_notifications';

  // Local Storage Keys
  static const String currentMemberKey = 'current_member';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'app_theme';

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int mobileNumberLength = 11;
}