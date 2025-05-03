import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class KycVerificationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _imagePicker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  // Document type
  final RxString documentType = 'aadhaar'.obs;

  // Document file and selfie file
  final RxString documentFile = ''.obs;
  final RxString selfieFile = ''.obs;
  final Rx<File?> documentImage = Rx<File?>(null);
  final Rx<File?> selfieImage = Rx<File?>(null);

  // Form validation
  final RxBool isDocumentValid = false.obs;
  final RxBool isSelfieValid = false.obs;
  final RxInt verificationProgress = 0.obs;

  void updateDocumentType(String type) {
    documentType.value = type;
  }

  Future<void> pickDocument() async {
    try {
      errorMessage.value = '';
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        documentImage.value = File(pickedFile.path);
        documentFile.value = pickedFile.name;
        isDocumentValid.value = true;
        _updateProgress();
      }
    } catch (e) {
      errorMessage.value = 'Failed to pick document: ${e.toString()}';
    }
  }

  void clearDocument() {
    documentFile.value = '';
    documentImage.value = null;
    isDocumentValid.value = false;
    _updateProgress();
  }

  Future<void> takeSelfie() async {
    try {
      errorMessage.value = '';
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        selfieImage.value = File(pickedFile.path);
        selfieFile.value = pickedFile.name;
        isSelfieValid.value = true;
        _updateProgress();
      }
    } catch (e) {
      errorMessage.value = 'Failed to take selfie: ${e.toString()}';
    }
  }

  void clearSelfie() {
    selfieFile.value = '';
    selfieImage.value = null;
    isSelfieValid.value = false;
    _updateProgress();
  }

  void _updateProgress() {
    int progress = 0;
    if (isDocumentValid.value) progress += 50;
    if (isSelfieValid.value) progress += 50;
    verificationProgress.value = progress;
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

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Submit KYC
      final success = await _authService.uploadKycDocument(
        documentType: documentType.value,
        documentFile: documentFile.value,
        selfieFile: selfieFile.value,
      );

      if (success) {
        isSuccess.value = true;
        
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setBool('kycVerified', true);

        // Show success message before navigation
        await Future.delayed(const Duration(seconds: 2));
        
        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        errorMessage.value = 'KYC verification failed. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'KYC verification failed: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
