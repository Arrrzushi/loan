import 'package:get/get.dart';

import '../../../data/models/loan_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/loan_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = true.obs;
  final RxList<LoanModel> loans = <LoanModel>[].obs;
  final RxString userName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadLoans();
  }

  Future<void> loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        userName.value = user.fullName;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    }
  }

  Future<void> loadLoans() async {
    isLoading.value = true;
    try {
      // In a real app, you would fetch loans from an API
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      loans.value = _loanService.getLoans();
      loans.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load loans');
    } finally {
      isLoading.value = false;
    }
  }

  double getTotalOutstandingAmount() {
    return loans
        .where((loan) => loan.status == 'approved')
        .fold(0, (sum, loan) => sum + loan.remainingAmount);
  }

  bool hasActiveLoans() {
    return loans.any((loan) => loan.status == 'approved');
  }

  LoanModel? getNextPaymentLoan() {
    if (!hasActiveLoans()) return null;

    // Get the loan with the closest due date
    return loans
        .where((loan) => loan.status == 'approved')
        .reduce((a, b) => a.dueDate.isBefore(b.dueDate) ? a : b);
  }

  void navigateToLoanApplication() {
    Get.snackbar('Coming Soon', 'Loan application will be available soon!');
  }

  void navigateToLoanDetails(LoanModel loan) {
    Get.snackbar('Coming Soon', 'Loan details will be available soon!');
  }

  void signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out');
    }
  }
}
