import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;

  // Login form data
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  // Mobile verification
  final RxString phoneNumber = ''.obs;
  final RxString otpCode = ''.obs;
  final RxBool isOtpSent = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void updateEmail(String value) {
    email.value = value;
    errorMessage.value = '';
  }

  void updatePassword(String value) {
    password.value = value;
    errorMessage.value = '';
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
    errorMessage.value = '';
  }

  void updateOtpCode(String value) {
    otpCode.value = value;
    errorMessage.value = '';
  }

  bool validateForm() {
    if (email.value.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }

    if (!GetUtils.isEmail(email.value)) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }

    if (password.value.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }

    return true;
  }

  bool validatePhoneNumber() {
    if (phoneNumber.value.isEmpty) {
      errorMessage.value = 'Please enter your phone number';
      return false;
    }

    if (!phoneNumber.value.startsWith('+')) {
      errorMessage.value = 'Phone number must include country code (e.g., +91)';
      return false;
    }

    return true;
  }

  bool validateOtp() {
    if (otpCode.value.isEmpty) {
      errorMessage.value = 'Please enter the OTP code';
      return false;
    }

    if (otpCode.value.length < 6) {
      errorMessage.value = 'Please enter a valid OTP code';
      return false;
    }

    return true;
  }

  Future<void> login() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      try {
        final user = await _authService.signIn(
          email: email.value,
          password: password.value,
        );

        if (user != null) {
          // Save login state
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Navigate to home or profile setup based on completeness
          if (!_authService.isProfileComplete) {
            Get.offAllNamed(Routes.PROFILE_SETUP);
          } else if (!_authService.isKycVerified) {
            Get.offAllNamed(Routes.KYC_VERIFICATION);
          } else {
            Get.offAllNamed(Routes.HOME);
          }
        } else {
          errorMessage.value = 'Invalid email or password';
        }
      } catch (pigeonError) {
        // If it's a PigeonUserDetails error
        if (pigeonError.toString().contains('PigeonUserDetails')) {
          // The user has likely been authenticated but there was an error with Pigeon
          // Try to recover by checking if the user exists in Firebase

          // Check if the user has been authenticated in Firebase
          if (_authService.isLoggedIn) {
            // Save login state
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);

            // Navigate to home or profile setup
            Get.offAllNamed(Routes.KYC_VERIFICATION);
            return;
          } else {
            // If authentication failed, show error
            errorMessage.value = 'Invalid email or password';
          }
        } else {
          // If it's not the Pigeon error, re-throw it
          rethrow;
        }
      }
    } catch (e) {
      if (e.toString().contains('user-not-found') ||
          e.toString().contains('wrong-password')) {
        errorMessage.value = 'Invalid email or password';
      } else {
        errorMessage.value = 'Login failed: ${e.toString()}';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to home or profile setup based on completeness
        if (!_authService.isProfileComplete) {
          Get.offAllNamed(Routes.PROFILE_SETUP);
        } else if (!_authService.isKycVerified) {
          Get.offAllNamed(Routes.KYC_VERIFICATION);
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      } else {
        errorMessage.value = 'Google sign-in failed';
      }
    } catch (e) {
      errorMessage.value = 'Google sign-in failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp() async {
    if (!validatePhoneNumber()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _authService.sendOtp(phoneNumber.value);

      if (success) {
        isOtpSent.value = true;
        Get.snackbar(
          'OTP Sent',
          'OTP has been sent to your mobile number',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = 'Failed to send OTP';
      }
    } catch (e) {
      errorMessage.value = 'Failed to send OTP: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!validateOtp()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _authService.verifyOtp(otpCode.value);

      if (success) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value = 'Invalid OTP code';
      }
    } catch (e) {
      errorMessage.value = 'OTP verification failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToRegister() async {
    Get.toNamed(Routes.PROFILE_SETUP);
  }

  Future<void> forgotPassword() async {
    if (email.value.isEmpty || !GetUtils.isEmail(email.value)) {
      errorMessage.value = 'Please enter a valid email';
      return;
    }

    try {
      isLoading.value = true;
      // Attempt to send password reset email
      await _authService.sendPasswordResetEmail(email.value);
      Get.snackbar(
        'Password Reset',
        'Password reset link has been sent to ${email.value}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send reset link: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      errorMessage.value = 'Error signing out. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
