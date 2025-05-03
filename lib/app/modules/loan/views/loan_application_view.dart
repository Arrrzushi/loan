import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/loan_application_controller.dart';

class LoanApplicationView extends GetView<LoanApplicationController> {
  const LoanApplicationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoanTypeSelector(context),
                const SizedBox(height: 24),
                _buildAmountSelector(context),
                const SizedBox(height: 24),
                _buildTenureSelector(context),
                const SizedBox(height: 24),
                _buildPurposeField(),
                const SizedBox(height: 32),
                _buildTermsAndConditions(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.termsAccepted.value
                        ? () => controller.submitApplication()
                        : null,
                    child: const Text('Submit Application'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildLoanTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loan Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: [
            _buildLoanTypeChip(context, 'Personal Loan', 'personal'),
            _buildLoanTypeChip(context, 'Business Loan', 'business'),
            _buildLoanTypeChip(context, 'Education Loan', 'education'),
            _buildLoanTypeChip(context, 'Home Loan', 'home'),
            _buildLoanTypeChip(context, 'Vehicle Loan', 'vehicle'),
          ],
        ),
        if (controller.loanTypeError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              controller.loanTypeError.value,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoanTypeChip(BuildContext context, String label, String value) {
    final isSelected = controller.selectedLoanType.value == value;
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (_) => controller.selectLoanType(value),
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildAmountSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Loan Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '₹${controller.selectedAmount.value.toStringAsFixed(0)}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          min: controller.minAmount,
          max: controller.maxAmount,
          divisions: 19, // Divisions for slider steps
          value: controller.selectedAmount.value,
          onChanged: (value) => controller.updateAmount(value),
          activeColor: Theme.of(context).primaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${controller.minAmount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              '₹${controller.maxAmount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTenureSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Loan Term',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${controller.selectedTenure.value} months',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          min: controller.minTenure.toDouble(),
          max: controller.maxTenure.toDouble(),
          divisions: controller.maxTenure - controller.minTenure,
          value: controller.selectedTenure.value.toDouble(),
          onChanged: (value) => controller.updateTenure(value.toInt()),
          activeColor: Theme.of(context).primaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${controller.minTenure} months',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              '${controller.maxTenure} months',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('EMI Amount'),
                    Obx(() => Text(
                      '₹${controller.emiAmount.value.toStringAsFixed(0)}/month',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Interest Rate'),
                    Text(
                      '${controller.interestRate.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Interest'),
                    Obx(() => Text(
                      '₹${controller.totalInterest.value.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount'),
                    Obx(() => Text(
                      '₹${controller.totalAmount.value.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Purpose of Loan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.purposeController,
          decoration: const InputDecoration(
            hintText: 'Briefly describe why you need this loan',
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the purpose of the loan';
            }
            if (value.trim().length < 10) {
              return 'Please provide more details (at least 10 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Obx(() => Checkbox(
          value: controller.termsAccepted.value,
          onChanged: (value) => controller.toggleTerms(),
        )),
        Expanded(
          child: GestureDetector(
            onTap: () => controller.toggleTerms(),
            child: const Text(
              'I have read and agree to the terms and conditions, privacy policy, and loan agreement',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

