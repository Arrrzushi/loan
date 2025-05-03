import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/services/loan_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoanManagementController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  final AuthService _authService = Get.find<AuthService>();
  
  final isLoading = true.obs;
  final loans = <LoanModel>[].obs;
  
  // Loan counts by status
  final activeLoansCount = 0.obs;
  final pendingLoansCount = 0.obs;
  final completedLoansCount = 0.obs;
  final rejectedLoansCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserLoans();
  }
  
  Future<void> loadUserLoans() async {
    isLoading.value = true;
    
    try {
      if (_authService.currentUser.value == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
      
      // Get user loans
      final userLoans = await _loanService.getUserLoansAsList();
      loans.assignAll(userLoans);
      
      // Update loan counts
      _updateLoanCounts();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load loans: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void _updateLoanCounts() {
    activeLoansCount.value = loans.where((loan) => loan.status == 'approved').length;
    pendingLoansCount.value = loans.where((loan) => loan.status == 'pending').length;
    completedLoansCount.value = loans.where((loan) => loan.status == 'closed').length;
    rejectedLoansCount.value = loans.where((loan) => loan.status == 'rejected').length;
  }
  
  void refreshLoans() {
    loadUserLoans();
  }
  
  void applyForNewLoan() {
    Get.toNamed(Routes.LOAN_APPLICATION);
  }
  
  void viewLoanDetails(String loanId) {
    Get.toNamed(Routes.LOAN_DETAILS, arguments: {'loanId': loanId});
  }
  
  Future<void> makePayment(String loanId) async {
    try {
      isLoading.value = true;
      
      // Find the loan to get EMI amount
      final loan = loans.firstWhere((loan) => loan.id == loanId);
      
      // Navigate to payment screen
      final result = await Get.toNamed(
        Routes.PAYMENT, 
        arguments: {
          'loanId': loanId,
          'amount': loan.emiAmount,
        }
      );
      
      // If payment was successful, refresh loans
      if (result == true) {
        await loadUserLoans();
        Get.snackbar('Success', 'Payment processed successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not process payment: $e');
    } finally {
      isLoading.value = false;
    }
  }
} 