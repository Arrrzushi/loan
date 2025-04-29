import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/loan_application_controller.dart';

class LoanApplicationView extends GetView<LoanApplicationController> {
  const LoanApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 24),
                  _buildAmountSection(context),
                  const SizedBox(height: 24),
                  _buildTenureSection(context),
                  const SizedBox(height: 24),
                  _buildEmiCalculationCard(context),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Loan Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Interest Rate: 10% per annum',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Minimum Amount: ₹5,000',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Maximum Amount: ₹10,00,000',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tenure: 3 to 36 months',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.amountController,
          keyboardType: TextInputType.number,
          validator: controller.validateAmount,
          decoration: const InputDecoration(
            labelText: 'Enter Amount',
            prefixText: '₹',
            hintText: '10000',
          ),
          onChanged: (value) {
            final amount = double.tryParse(value);
            if (amount != null) {
              controller.updateAmount(amount);
            }
          },
        ),
        const SizedBox(height: 16),
        Obx(() => Text(
              'Selected: ${currencyFormat.format(controller.selectedAmount.value)}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            )),
        const SizedBox(height: 8),
        Obx(() => Slider(
              min: 5000,
              max: 1000000,
              divisions: 100,
              value: controller.selectedAmount.value,
              label: currencyFormat.format(controller.selectedAmount.value),
              onChanged: controller.updateAmount,
            )),
      ],
    );
  }

  Widget _buildTenureSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loan Tenure',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.tenureController,
          keyboardType: TextInputType.number,
          validator: controller.validateTenure,
          decoration: const InputDecoration(
            labelText: 'Enter Tenure',
            suffixText: 'months',
            hintText: '12',
          ),
          onChanged: (value) {
            final tenure = int.tryParse(value);
            if (tenure != null) {
              controller.updateTenure(tenure);
            }
          },
        ),
        const SizedBox(height: 16),
        Obx(() => Text(
              'Selected: ${controller.selectedTenure.value} months',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            )),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: controller.tenureOptions.map((months) {
            return Obx(() => ChoiceChip(
                  label: Text('$months months'),
                  selected: controller.selectedTenure.value == months,
                  onSelected: (selected) {
                    if (selected) {
                      controller.updateTenure(months);
                    }
                  },
                ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmiCalculationCard(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '₹',
      locale: 'en_IN',
      decimalDigits: 2,
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EMI Calculation',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Monthly EMI'),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          currencyFormat.format(controller.emiAmount.value),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount'),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          currencyFormat.format(controller.emiAmount.value *
                              controller.selectedTenure.value),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Principal', style: TextStyle(color: Colors.grey[600])),
                Obx(() => Text(
                      currencyFormat.format(controller.selectedAmount.value),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interest', style: TextStyle(color: Colors.grey[600])),
                Obx(() => Text(
                      currencyFormat.format((controller.emiAmount.value *
                              controller.selectedTenure.value) -
                          controller.selectedAmount.value),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
          onPressed:
              controller.isLoading.value ? null : controller.applyForLoan,
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Apply for Loan'),
        ));
  }

  Widget _buildErrorMessage() {
    return Obx(() {
      if (controller.errorMessage.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        ),
      );
    });
  }
}
