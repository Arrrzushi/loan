import 'package:get/get.dart';
import '../controllers/loan_details_controller.dart';

class LoanDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanDetailsController>(
      () => LoanDetailsController(),
    );
  }
} 