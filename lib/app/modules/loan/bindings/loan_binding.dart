import 'package:get/get.dart';

import '../controllers/loan_application_controller.dart';

class LoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanApplicationController>(
      () => LoanApplicationController(),
    );
  }
}
