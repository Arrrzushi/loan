import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../controllers/admin_loans_controller.dart';
import '../controllers/admin_users_controller.dart';
import '../controllers/admin_loan_details_controller.dart';
import '../controllers/admin_user_loans_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    // Register dashboard controller
    Get.lazyPut<AdminDashboardController>(
      () => AdminDashboardController(),
    );
    
    // Register loans controller
    Get.lazyPut<AdminLoansController>(
      () => AdminLoansController(),
    );
    
    // Register users controller
    Get.lazyPut<AdminUsersController>(
      () => AdminUsersController(),
    );
    
    // Register loan details controller
    Get.lazyPut<AdminLoanDetailsController>(
      () => AdminLoanDetailsController(),
    );
    
    // Register user loans controller
    Get.lazyPut<AdminUserLoansController>(
      () => AdminUserLoansController(),
    );
  }
} 