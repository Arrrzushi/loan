import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../data/services/loan_service.dart';
import '../../../routes/app_pages.dart';

class LoanApplicationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final LoanService _loanService = Get.find<LoanService>();

  final amountController = TextEditingController();
  final tenureController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxDouble selectedAmount = 10000.0.obs;
  final RxInt selectedTenure = 12.obs;

  final RxDouble emiAmount = 0.0.obs;

  final List<int> tenureOptions = [3, 6, 12, 24, 36];

  // Loan application form data
  final RxDouble loanAmount = 20000.0.obs;
  final RxInt tenureMonths = 12.obs;
  final RxString loanType = 'personal'.obs;
  final RxString purpose = 'Personal Expense'.obs;

  // User income and employment details
  final RxString employmentType = 'Salaried'.obs;
  final RxDouble monthlyIncome = 50000.0.obs;
  final RxString companyName = ''.obs;
  final RxInt workExperienceYears = 2.obs;

  @override
  void onInit() {
    super.onInit();
    updateEMI();
  }

  @override
  void onClose() {
    amountController.dispose();
    tenureController.dispose();
    super.onClose();
  }

  void updateAmount(double value) {
    selectedAmount.value = value;
    amountController.text = value.toStringAsFixed(0);
    updateEMI();
  }

  void updateTenure(int value) {
    selectedTenure.value = value;
    tenureController.text = value.toString();
    updateEMI();
  }

  void updateEMI() {
    // Calculate EMI using the formula: EMI = P * r * (1+r)^n / ((1+r)^n - 1)
    // where P = Principal, r = monthly interest rate, n = tenure in months
    final interestRate = 10.0; // 10% per annum
    final monthlyInterestRate = interestRate / (12 * 100);

    final P = selectedAmount.value;
    final r = monthlyInterestRate;
    final n = selectedTenure.value;

    final emi = (P * r * _pow(1 + r, n)) / (_pow(1 + r, n) - 1);
    emiAmount.value = emi;
  }

  double _pow(double x, int y) {
    double result = 1.0;
    for (int i = 0; i < y; i++) {
      result *= x;
    }
    return result;
  }

  void updateLoanAmount(double value) {
    loanAmount.value = value;
  }

  void updateTenureMonths(int value) {
    tenureMonths.value = value;
  }

  void updateLoanType(String value) {
    loanType.value = value;
  }

  void updatePurpose(String value) {
    purpose.value = value;
  }

  void updateEmploymentType(String value) {
    employmentType.value = value;
  }

  void updateMonthlyIncome(double value) {
    monthlyIncome.value = value;
  }

  void updateCompanyName(String value) {
    companyName.value = value;
  }

  void updateWorkExperience(int value) {
    workExperienceYears.value = value;
  }

  bool validateForm() {
    if (loanAmount.value < 5000) {
      errorMessage.value = 'Loan amount must be at least ₹5,000';
      return false;
    }

    if (tenureMonths.value < 3) {
      errorMessage.value = 'Loan tenure must be at least 3 months';
      return false;
    }

    if (purpose.value.isEmpty) {
      errorMessage.value = 'Please specify loan purpose';
      return false;
    }

    if (monthlyIncome.value < 15000) {
      errorMessage.value = 'Monthly income must be at least ₹15,000';
      return false;
    }

    if (companyName.value.isEmpty && employmentType.value == 'Salaried') {
      errorMessage.value = 'Please enter your company name';
      return false;
    }

    return true;
  }

  Future<void> applyForLoan() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await _loanService.applyForLoan(
        amount: loanAmount.value,
        tenureMonths: tenureMonths.value,
        loanType: loanType.value,
        purpose: purpose.value,
      );

      if (success) {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Application Submitted',
          'Your loan application has been submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        errorMessage.value = 'Failed to submit loan application';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter loan amount';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount < 5000) {
      return 'Minimum loan amount is ₹5,000';
    }

    if (amount > 1000000) {
      return 'Maximum loan amount is ₹10,00,000';
    }

    return null;
  }

  String? validateTenure(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter loan tenure';
    }

    final tenure = int.tryParse(value);
    if (tenure == null) {
      return 'Please enter a valid tenure';
    }

    if (tenure < 3) {
      return 'Minimum tenure is 3 months';
    }

    if (tenure > 36) {
      return 'Maximum tenure is 36 months';
    }

    return null;
  }
}
