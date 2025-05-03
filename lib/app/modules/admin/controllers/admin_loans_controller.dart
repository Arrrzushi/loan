import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/services/loan_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AdminLoansController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = true.obs;
  final loans = <LoanModel>[].obs;
  final filteredLoans = <LoanModel>[].obs;
  final selectedStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Check if user is admin
    if (!_authService.isAdmin) {
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Access Denied', 'You do not have admin privileges');
      return;
    }
    
    loadLoans();
  }
  
  Future<void> loadLoans() async {
    isLoading.value = true;
    
    try {
      final loansList = await _loanService.getAllLoans();
      loans.assignAll(loansList);
      
      // Initially show all loans
      filteredLoans.assignAll(loansList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load loans: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void refreshLoans() {
    loadLoans();
  }
  
  void filterByStatus(String status) {
    selectedStatus.value = status;
    
    if (status.isEmpty) {
      // Show all loans
      filteredLoans.assignAll(loans);
    } else {
      // Filter by status
      filteredLoans.assignAll(
        loans.where((loan) => loan.status == status).toList()
      );
    }
  }
  
  void clearFilters() {
    selectedStatus.value = '';
    filteredLoans.assignAll(loans);
  }
  
  void showFilterOptions() {
    // In the real implementation, this would show a bottom sheet with filter options
    // The UI components should be in the view, not the controller
    Get.snackbar('Filters', 'Status filter: ${selectedStatus.value.isEmpty ? 'All' : selectedStatus.value.capitalize}');
  }
  
  void viewLoanDetails(String loanId) {
    Get.toNamed(
      Routes.ADMIN_LOAN_DETAILS,
      arguments: {'loanId': loanId},
    );
  }
  
  Future<void> approveLoan(String loanId) async {
    try {
      final result = await _loanService.approveLoan(loanId);
      
      if (result) {
        Get.snackbar('Success', 'Loan approved successfully');
        await loadLoans();
      } else {
        Get.snackbar('Error', 'Failed to approve loan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve loan: $e');
    }
  }
  
  Future<void> rejectLoan(String loanId) async {
    try {
      final result = await _loanService.rejectLoan(loanId);
      
      if (result) {
        Get.snackbar('Success', 'Loan rejected successfully');
        await loadLoans();
      } else {
        Get.snackbar('Error', 'Failed to reject loan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject loan: $e');
    }
  }
  
  String getUserName(String userId) {
    // In a real app, this would be fetched from a user service
    return 'User $userId';
  }
} 