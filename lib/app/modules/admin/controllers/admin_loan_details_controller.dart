import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/services/loan_service.dart';

class AdminLoanDetailsController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  
  final isLoading = true.obs;
  final loan = Rx<LoanModel?>(null);
  final userName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadLoanDetails();
  }
  
  Future<void> _loadLoanDetails() async {
    try {
      isLoading.value = true;
      
      // Get loan ID from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null || !args.containsKey('loanId')) {
        Get.snackbar('Error', 'Loan ID not provided');
        Get.back();
        return;
      }
      
      final loanId = args['loanId'] as String;
      
      // Get loan details
      final allLoans = await _loanService.getAllLoans();
      final selectedLoan = allLoans.firstWhereOrNull((loan) => loan.id == loanId);
      
      if (selectedLoan == null) {
        Get.snackbar('Error', 'Loan not found');
        Get.back();
        return;
      }
      
      loan.value = selectedLoan;
      
      // Set user name (in a real app, this would fetch from a user service)
      userName.value = 'User ${selectedLoan.userId}';
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load loan details: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> approveLoan() async {
    if (loan.value == null) return;
    
    try {
      final result = await _loanService.approveLoan(loan.value!.id);
      
      if (result) {
        Get.snackbar('Success', 'Loan approved successfully');
        await _loadLoanDetails();
      } else {
        Get.snackbar('Error', 'Failed to approve loan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve loan: $e');
    }
  }
  
  Future<void> rejectLoan() async {
    if (loan.value == null) return;
    
    try {
      final result = await _loanService.rejectLoan(loan.value!.id);
      
      if (result) {
        Get.snackbar('Success', 'Loan rejected successfully');
        await _loadLoanDetails();
      } else {
        Get.snackbar('Error', 'Failed to reject loan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject loan: $e');
    }
  }
} 