import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kyc_verification_controller.dart';

class KycVerificationView extends GetView<KycVerificationController> {
  const KycVerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            color: Color(0xFF333333),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header text
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
                  'We need to verify your identity to comply with regulations',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 32),

                // Error message
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
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
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                // Document type selector
                const Text(
                  'ID Document Type',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDocumentTypeOption(
                            'Aadhaar Card',
                            'aadhaar',
                            Icons.perm_identity,
                          ),
                          const Divider(height: 1),
                          _buildDocumentTypeOption(
                            'PAN Card',
                            'pan',
                            Icons.credit_card,
                          ),
                          const Divider(height: 1),
                          _buildDocumentTypeOption(
                            'Driving License',
                            'driving_license',
                            Icons.drive_eta,
                          ),
                          const Divider(height: 1),
                          _buildDocumentTypeOption(
                            'Voter ID',
                            'voter_id',
                            Icons.how_to_vote,
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 32),

                // Document upload section
                const Text(
                  'Upload Document',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: controller.documentFile.value.isEmpty
                          ? InkWell(
                              onTap: controller.pickDocument,
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_file,
                                    size: 50,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tap to upload document',
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'JPG, PNG or PDF (Max 5MB)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 50,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.documentFile.value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade400,
                                    ),
                                    onPressed: controller.clearDocument,
                                  ),
                                ),
                              ],
                            ),
                    )),
                const SizedBox(height: 16),

                // Self capture
                const Text(
                  'Take a Selfie',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
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
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: controller.selfieFile.value.isEmpty
                          ? InkWell(
                              onTap: controller.takeSelfie,
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Tap to take a selfie',
                                    style: TextStyle(
                                      color: Color(0xFF757575),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 50,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.selfieFile.value,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade400,
                                    ),
                                    onPressed: controller.clearSelfie,
                                  ),
                                ),
                              ],
                            ),
                    )),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitKyc,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7E1D),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Submit for Verification',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTypeOption(
    String title,
    String value,
    IconData icon,
  ) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(
            icon,
            color: controller.documentType.value == value
                ? const Color(0xFFFF7E1D)
                : Colors.grey.shade700,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: controller.documentType.value == value
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: controller.documentType.value == value
                  ? const Color(0xFF333333)
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
      value: value,
      groupValue: controller.documentType.value,
      onChanged: (value) {
        if (value != null) controller.updateDocumentType(value);
      },
      activeColor: const Color(0xFFFF7E1D),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    );
  }
}
