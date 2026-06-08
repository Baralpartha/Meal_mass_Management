class AppStrings {
  AppStrings._();

  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String logout = 'Logout';
  static const String mobileNumber = 'Mobile Number';
  static const String password = 'Password';
  static const String fullName = 'Full Name';
  static const String district = 'District';
  static const String thana = 'Thana';
  static const String address = 'Address';
  static const String loginSuccess = 'Login successful';
  static const String registrationSuccess = 'Registration submitted. Wait for admin approval.';
  static const String invalidCredentials = 'Invalid mobile number or password';
  static const String accountPending = 'Your account is pending approval';
  static const String accountRejected = 'Your account has been rejected';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String totalMembers = 'Total Members';
  static const String pendingMembers = 'Pending Members';
  static const String totalMealUnits = 'Total Meal Units';
  static const String totalBazar = 'Total Bazar';
  static const String totalDeposit = 'Total Deposit';
  static const String mealRate = 'Meal Rate';
  static const String currentBalance = 'Current Balance';

  // Members
  static const String members = 'Members';
  static const String approveMember = 'Approve Member';
  static const String rejectMember = 'Reject Member';
  static const String approved = 'Approved';
  static const String pending = 'Pending';
  static const String rejected = 'Rejected';
  static const String inactive = 'Inactive';

  // Cycles
  static const String cycles = 'Cycles';
  static const String startCycle = 'Start New Cycle';
  static const String closeCycle = 'Close Cycle';
  static const String cycleCode = 'Cycle Code';
  static const String startDate = 'Start Date';
  static const String endDate = 'End Date';
  static const String running = 'Running';
  static const String closed = 'Closed';

  // Meals
  static const String meals = 'Meals';
  static const String addMeal = 'Add Meal';
  static const String fullMeal = 'Full Meal';
  static const String halfMeal = 'Half Meal';
  static const String quantity = 'Quantity';
  static const String mealDate = 'Meal Date';
  static const String note = 'Note';

  // Bazar
  static const String bazar = 'Bazar';
  static const String addBazar = 'Add Bazar';
  static const String description = 'Description';
  static const String amount = 'Amount';
  static const String bazarDate = 'Bazar Date';

  // Deposits
  static const String deposits = 'Deposits';
  static const String addDeposit = 'Add Deposit';
  static const String depositDate = 'Deposit Date';

  // Khala Bill
  static const String khalaBill = 'Khala Bill';
  static const String addKhalaBill = 'Add Khala Bill';
  static const String billDate = 'Bill Date';

  // Notifications
  static const String notifications = 'Notifications';
  static const String markAsRead = 'Mark as Read';
  static const String noNotifications = 'No notifications yet';

  // Reports
  static const String reports = 'Reports';
  static const String cycleReport = 'Cycle Report';
  static const String memberReport = 'Member Report';
  static const String exportPdf = 'Export PDF';

  // Common
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirm = 'Confirm';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String retry = 'Retry';
  static const String selectDate = 'Select Date';
  static const String selectMember = 'Select Member';

  // Errors
  static const String networkError = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String fieldRequired = 'This field is required';
  static const String invalidMobile = 'Enter a valid 11-digit mobile number';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String invalidAmount = 'Enter a valid positive amount';
  static const String invalidQuantity = 'Enter a valid positive quantity';
}