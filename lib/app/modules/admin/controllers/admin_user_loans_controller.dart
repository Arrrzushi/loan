import 'package:get/get.dart';
import '../../../data/models/loan_model.dart';
import '../../../data/services/loan_service.dart';
import '../../../routes/app_pages.dart';

class AdminUserLoansController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  
  final isLoading = true.obs;
  final loans = <LoanModel>[].obs;
  final userId = ''.obs;
  final userName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserLoans();
  }
  
  Future<void> _loadUserLoans() async {
    try {
      isLoading.value = true;
      
      // Get user ID from arguments
      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null || !args.containsKey('userId')) {
        Get.snackbar('Error', 'User ID not provided');
        Get.back();
        return;
      }
      
      userId.value = args['userId'] as String;
      userName.value = args['userName'] as String? ?? 'User ${userId.value}';
      
      // Get all loans
      final allLoans = await _loanService.getAllLoans();
      
      // Filter loans for the specific user
      loans.assignAll(
        allLoans.where((loan) => loan.userId == userId.value).toList()
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user loans: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void refreshLoans() {
    _loadUserLoans();
  }
  
  void viewLoanDetails(String loanId) {
    Get.toNamed(
      Routes.ADMIN_LOAN_DETAILS,
      arguments: {'loanId': loanId},
    );
  }
  
  int get pendingLoansCount => 
    loans.where((loan) => loan.status == 'pending').length;
    
  int get approvedLoansCount => 
    loans.where((loan) => loan.status == 'approved').length;
    
  int get rejectedLoansCount => 
    loans.where((loan) => loan.status == 'rejected').length;
    
  int get closedLoansCount => 
    loans.where((loan) => loan.status == 'closed').length;
    
  double get totalLoanAmount => 
    loans.fold(0.0, (sum, loan) => sum + loan.amount);
    
  double get disbursedAmount => 
    loans.where((loan) => loan.status == 'approved' || loan.status == 'closed')
      .fold(0.0, (sum, loan) => sum + loan.amount);
} 