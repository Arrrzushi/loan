import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/loan_service.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class AdminDashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LoanService _loanService = Get.find<LoanService>();

  final isLoading = true.obs;
  final loans = <LoanModel>[].obs;
  final users = <UserModel>[].obs;
  
  // Dashboard statistics
  final totalUsers = 0.obs;
  final totalLoans = 0.obs;
  final pendingLoans = 0.obs;
  final approvedLoans = 0.obs;
  final rejectedLoans = 0.obs;
  final closedLoans = 0.obs;
  final totalLoanAmount = 0.0.obs;
  final disbursedAmount = 0.0.obs;
  
  // Tab navigation
  final selectedTabIndex = 0.obs;
  
  // Loan lists
  final pendingLoansList = <LoanModel>[].obs;
  final activeLoansList = <LoanModel>[].obs;
  final allLoansList = <LoanModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Check if user is admin
    if (!_authService.isAdmin) {
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Access Denied', 'You do not have admin privileges');
      return;
    }
    
    loadData();
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    
    try {
      // Load users
      final usersList = await _authService.getAllUsers();
      users.assignAll(usersList);
      totalUsers.value = users.length;
      
      // Load loans
      final loansList = await _loanService.getAllLoans();
      loans.assignAll(loansList);
      totalLoans.value = loans.length;
      
      // Calculate statistics
      pendingLoans.value = loans.where((loan) => loan.status == 'pending').length;
      approvedLoans.value = loans.where((loan) => loan.status == 'approved').length;
      rejectedLoans.value = loans.where((loan) => loan.status == 'rejected').length;
      closedLoans.value = loans.where((loan) => loan.status == 'closed').length;
      
      // Calculate total amount
      totalLoanAmount.value = loans.fold(0.0, (sum, loan) => sum + loan.amount);
      
      // Calculate disbursed amount (approved + closed loans)
      disbursedAmount.value = loans
          .where((loan) => loan.status == 'approved' || loan.status == 'closed')
          .fold(0.0, (sum, loan) => sum + loan.amount);
      
      // Filter loans
      pendingLoansList.assignAll(
        loansList.where((loan) => loan.status == 'pending').toList()
      );
      
      activeLoansList.assignAll(
        loansList.where((loan) => loan.status == 'approved').toList()
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void changeTab(int index) {
    selectedTabIndex.value = index;
    
    switch (index) {
      case 0: // Dashboard
        // Already on dashboard
        break;
      case 1: // Users
        Get.toNamed(Routes.ADMIN_USERS);
        break;
      case 2: // Loans
        Get.toNamed(Routes.ADMIN_LOANS);
        break;
      case 3: // Settings
        Get.toNamed(Routes.ADMIN_SETTINGS);
        break;
    }
  }
  
  Future<void> approveLoan(String loanId) async {
    try {
      isLoading.value = true;
      await _loanService.approveLoan(loanId);
      Get.snackbar('Success', 'Loan approved successfully');
      await loadData(); // Reload data
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve loan: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> rejectLoan(String loanId) async {
    try {
      isLoading.value = true;
      await _loanService.rejectLoan(loanId);
      Get.snackbar('Success', 'Loan rejected');
      await loadData(); // Reload data
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject loan: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void viewLoanDetails(String loanId) {
    Get.toNamed(Routes.ADMIN_LOAN_DETAILS, arguments: {'loanId': loanId});
  }
  
  UserModel? getUserById(String userId) {
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }
  
  void logout() {
    _authService.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
  
  void refreshData() {
    loadData();
  }
  
  void navigateToUsers() {
    Get.toNamed(Routes.ADMIN_USERS);
  }
  
  void navigateToLoans() {
    Get.toNamed(Routes.ADMIN_LOANS);
  }
  
  void navigateToSettings() {
    Get.snackbar('Coming Soon', 'Settings page will be available soon');
  }
  
  void viewPendingLoans() {
    Get.toNamed(Routes.ADMIN_LOANS, arguments: {'filter': 'pending'});
  }
  
  List<LoanModel> getRecentLoans() {
    // Sort loans by application date (most recent first) and return top 5
    final sortedLoans = loans.toList()
      ..sort((a, b) => b.applicationDate.compareTo(a.applicationDate));
    
    return sortedLoans.take(5).toList();
  }
} 