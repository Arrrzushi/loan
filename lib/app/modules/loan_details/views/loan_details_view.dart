import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../data/models/loan_model.dart';
import '../controllers/loan_details_controller.dart';

class LoanDetailsView extends GetView<LoanDetailsController> {
  const LoanDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final loan = controller.loan.value;
        if (loan == null) {
          return const Center(child: Text('Loan not found'));
        }

        return Center(
          child: Container(
            width: 320,
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.arrowLeft,
                          color: Colors.grey[700]),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      'Loan Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(width: 24),
                  ],
                ),

                // Black loan status box
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Loan Status',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 10)),
                          Text('Due Amount',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${NumberFormat('#,##0.00').format(loan.amount)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => controller.handleRepayment(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Pay now'),
                      ),
                    ],
                  ),
                ),

                // User's Loan Summary
                Text('${loan.userName}\'s Loan Summary',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12)),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildLoanSummaryRow('Total Cost', loan.amount),
                      _buildLoanSummaryRow('Interest Rate', loan.interestRate),
                      _buildLoanSummaryRow('Interest', loan.interestAmount),
                    ],
                  ),
                ),

                // Updates header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Updates',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                    TextButton(
                      onPressed: () => controller.viewAllUpdates(),
                      child: Text('View All',
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                  ],
                ),

                // Updates list
                Column(
                  children: [
                    _buildUpdateButton('Loan payment reminder'),
                    _buildUpdateButton('Loan assistance available'),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.home),
              onPressed: () => Get.toNamed('/home'),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.search),
              onPressed: () => Get.toNamed('/search'),
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.cog),
              onPressed: () => Get.toNamed('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanSummaryRow(String title, double value) {
    return Row(
      children: [
        Container(
          width: 80,
          child: Text(title,
              style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: value / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 40,
          child: Text('${value.toInt()}%',
              style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        ),
      ],
    );
  }

  Widget _buildUpdateButton(String title) {
    return ElevatedButton(
      onPressed: () => controller.handleUpdate(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(FontAwesomeIcons.bell, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 10)),
            ],
          ),
          Icon(FontAwesomeIcons.chevronRight, color: Colors.grey[700]),
        ],
      ),
    );
  }
}
