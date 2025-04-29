import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/profile_setup_controller.dart';
import '../controllers/kyc_verification_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<ProfileSetupController>(
      () => ProfileSetupController(),
    );
    Get.lazyPut<KycVerificationController>(
      () => KycVerificationController(),
    );
  }
}
