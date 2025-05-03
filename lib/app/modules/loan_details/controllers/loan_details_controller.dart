import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/services/loan_service.dart';

class LoanDetailsController extends GetxController {
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
        print('Error: Loan ID not provided');
        Future.microtask(() => Get.back());
        return;
      }
      
      final loanId = args['loanId'] as String;
      
      // Get loan details
      final allLoans = await _loanService.getAllLoans();
      final selectedLoan = allLoans.firstWhereOrNull((loan) => loan.id == loanId);
      
      if (selectedLoan == null) {
        print('Error: Loan not found');
        Future.microtask(() => Get.back());
        return;
      }
      
      loan.value = selectedLoan;
      
      // Set user name (in a real app, you would fetch this from a user service)
      userName.value = 'Customer'; // Placeholder
      
    } catch (e) {
      print('Error: Failed to load loan details: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void handleRepayment() {
    if (loan.value == null) return;
    
    // Navigate to payment screen
    Get.toNamed('/payment', arguments: {
      'loanId': loan.value!.id,
      'amount': loan.value!.emiAmount,
      'dueDate': loan.value!.dueDate,
    });
  }
  
  void viewAllUpdates() {
    Get.snackbar('Coming Soon', 'This feature will be available soon');
  }
  
  void handleUpdate(String title) {
    Get.snackbar('Update', 'Processing $title');
  }
}
