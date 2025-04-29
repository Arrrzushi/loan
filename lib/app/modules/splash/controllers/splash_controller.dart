import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    try {
      // Delay to show splash screen
      await Future.delayed(const Duration(seconds: 2));

      // ALWAYS force to show onboarding for demo
      Get.offAllNamed(Routes.ONBOARDING);

      /* The normal flow would be:
      final prefs = await SharedPreferences.getInstance();
      final isFirstRun = prefs.getBool('isFirstRun') ?? true;

      if (isFirstRun) {
        // First time - go to onboarding
        await prefs.setBool('isFirstRun', false);
        Get.offAllNamed(Routes.ONBOARDING);
      } else {
        // Not first time - check if logged in
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (isLoggedIn) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      }
      */
    } catch (e) {
      debugPrint('Error in splash controller: $e');
      // If any error occurs, go to onboarding
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}
