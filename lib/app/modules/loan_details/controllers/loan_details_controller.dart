import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/providers/loan_provider.dart';

class LoanDetailsController extends GetxController {
  final LoanProvider _loanProvider = Get.find<LoanProvider>();

  final Rx<LoanModel?> loan = Rx<LoanModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadLoanDetails();
  }

  Future<void> loadLoanDetails() async {
    try {
      isLoading.value = true;
      // TODO: Replace with actual loan ID from route parameters
      final loanId = Get.parameters['id'];
      if (loanId != null) {
        final loanData = await _loanProvider.getLoanDetails(loanId);
        loan.value = loanData;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load loan details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleRepayment() {
    // TODO: Implement repayment logic
    Get.snackbar(
      'Coming Soon',
      'Repayment functionality will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void handleUpdate(String updateTitle) {
    // TODO: Implement update handling logic
    Get.snackbar(
      'Update',
      'Handling update: $updateTitle',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewAllUpdates() {
    // TODO: Navigate to updates screen
    Get.snackbar(
      'Coming Soon',
      'Updates screen will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
