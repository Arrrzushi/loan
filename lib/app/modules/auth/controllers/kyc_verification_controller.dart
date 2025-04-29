import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class KycVerificationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Document type
  final RxString documentType = 'aadhaar'.obs;

  // Document file and selfie file
  final RxString documentFile = ''.obs;
  final RxString selfieFile = ''.obs;

  void updateDocumentType(String type) {
    documentType.value = type;
  }

  Future<void> pickDocument() async {
    try {
      // In a real app, you would use image_picker to pick a document
      // For now, show a confirmation dialog first
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Select Document'),
          content: const Text(
              'Would you normally select a document from your gallery or camera here. For this demo, we\'ll use a placeholder.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        documentFile.value = 'document.jpg';
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick document: ${e.toString()}';
    }
  }

  void clearDocument() {
    documentFile.value = '';
  }

  Future<void> takeSelfie() async {
    try {
      // In a real app, you would use image_picker to take a selfie
      // For now, show a confirmation dialog first
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Take Selfie'),
          content: const Text(
              'Would you normally take a selfie using your camera here. For this demo, we\'ll use a placeholder.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await Future.delayed(const Duration(milliseconds: 500));
        selfieFile.value = 'selfie.jpg';
      }
    } catch (e) {
      errorMessage.value = 'Failed to take selfie: ${e.toString()}';
    }
  }

  void clearSelfie() {
    selfieFile.value = '';
  }

  bool validateForm() {
    if (documentFile.value.isEmpty) {
      errorMessage.value = 'Please upload your ID document';
      return false;
    }

    if (selfieFile.value.isEmpty) {
      errorMessage.value = 'Please take a selfie';
      return false;
    }

    return true;
  }

  Future<void> submitKyc() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Submit KYC
      final success = await _authService.uploadKycDocument(
        documentType: documentType.value,
        documentFile: documentFile.value,
        selfieFile: selfieFile.value,
      );

      if (success) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value = 'KYC verification failed';
      }
    } catch (e) {
      errorMessage.value = 'KYC verification failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
