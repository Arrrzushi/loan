import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/kyc_verification_controller.dart';

class KycVerificationView extends GetView<KycVerificationController> {
  const KycVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Identity Verification',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF333333),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Show loading state
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 24),
                  const Text(
                    'Verifying your documents...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Show success state
          if (controller.isSuccess.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: Colors.green,
                    size: 80,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Verification Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your identity has been verified. Redirecting to dashboard...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Normal form view
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressIndicator(primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Header section
                  _buildHeaderSection(),
                  const SizedBox(height: 20),
                  
                  // Error message
                  _buildErrorMessage(),
                  
                  // Document type selector
                  _buildDocumentTypeSection(),
                  const SizedBox(height: 24),
                  
                  // Document upload section
                  _buildDocumentUploadSection(primaryColor),
                  const SizedBox(height: 24),
                  
                  // Selfie section
                  _buildSelfieSection(primaryColor),
                  const SizedBox(height: 32),
                  
                  // Submit button
                  _buildSubmitButton(primaryColor),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildProgressIndicator(Color primaryColor) {
    return Column(
      children: [
        Obx(() => CircularPercentIndicator(
          radius: 60.0,
          lineWidth: 10.0,
          animation: true,
          percent: controller.verificationProgress.value / 100,
          center: Text(
            "${controller.verificationProgress.value}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: primaryColor,
          backgroundColor: Colors.grey[200]!,
        )),
        const SizedBox(height: 12),
        const Text(
          'KYC Verification Progress',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify Your Identity',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'To comply with regulations and ensure your security, we need to verify your identity. Please provide the following information.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }
  
  Widget _buildErrorMessage() {
    return Obx(() => controller.errorMessage.value.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => controller.errorMessage.value = '',
                  color: Colors.red.shade700,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          )
        : const SizedBox.shrink());
  }
  
  Widget _buildDocumentTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              FontAwesomeIcons.idCard,
              size: 18,
              color: Color(0xFF333333),
            ),
            SizedBox(width: 8),
            Text(
              'ID Document Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the type of document you wish to upload',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDocumentTypeOption(
                'Aadhaar Card',
                'aadhaar',
                FontAwesomeIcons.idCard,
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildDocumentTypeOption(
                'PAN Card',
                'pan',
                FontAwesomeIcons.creditCard,
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildDocumentTypeOption(
                'Driving License',
                'driving_license',
                FontAwesomeIcons.carSide,
              ),
              Divider(height: 1, color: Colors.grey.shade200),
              _buildDocumentTypeOption(
                'Voter ID',
                'voter_id',
                FontAwesomeIcons.personBooth,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDocumentTypeOption(String title, String value, IconData icon) {
    return Obx(() => InkWell(
          onTap: () => controller.updateDocumentType(value),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: controller.documentType.value == value
                      ? Theme.of(Get.context!).colorScheme.primary
                      : Colors.grey.shade600,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: controller.documentType.value == value
                        ? Colors.black
                        : Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Radio<String>(
                  value: value,
                  groupValue: controller.documentType.value,
                  onChanged: (v) => controller.updateDocumentType(v!),
                  activeColor: Theme.of(Get.context!).colorScheme.primary,
                ),
              ],
            ),
          ),
        ));
  }
  
  Widget _buildDocumentUploadSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              FontAwesomeIcons.fileUpload,
              size: 18,
              color: Color(0xFF333333),
            ),
            SizedBox(width: 8),
            Text(
              'Upload Document',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
              'Upload your ${controller.documentType.value.replaceAll('_', ' ').capitalizeFirst} (front side)',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            )),
        const SizedBox(height: 12),
        Obx(() => Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.isDocumentValid.value
                      ? Colors.green.shade300
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: controller.documentFile.value.isEmpty
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.pickDocument,
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.fileUpload,
                              size: 36,
                              color: primaryColor.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tap to upload document',
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'JPG, PNG or PDF (Max 5MB)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        controller.documentImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.documentImage.value!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 42,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    controller.documentFile.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: controller.clearDocument,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            )),
      ],
    );
  }
  
  Widget _buildSelfieSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              FontAwesomeIcons.camera,
              size: 18,
              color: Color(0xFF333333),
            ),
            SizedBox(width: 8),
            Text(
              'Take a Selfie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'We need a clear photo of your face for verification',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.isSelfieValid.value
                      ? Colors.green.shade300
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: controller.selfieFile.value.isEmpty
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.takeSelfie,
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.camera,
                              size: 36,
                              color: primaryColor.withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tap to take a selfie',
                              style: TextStyle(
                                color: Color(0xFF424242),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Make sure your face is clearly visible',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        controller.selfieImage.value != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.selfieImage.value!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 42,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    controller.selfieFile.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap: controller.clearSelfie,
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            )),
      ],
    );
  }
  
  Widget _buildSubmitButton(Color primaryColor) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: () => controller.submitKyc(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit Documents',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Complete Later'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Information is Secure',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We use bank-level encryption to protect your data and keep your identity safe.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
