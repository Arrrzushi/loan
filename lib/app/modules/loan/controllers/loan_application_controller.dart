import 'dart:math';
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
  final purposeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxDouble selectedAmount = 100000.0.obs;
  final RxInt selectedTenure = 12.obs;
  final RxString selectedLoanType = ''.obs;
  final RxString loanTypeError = ''.obs;
  final RxBool termsAccepted = false.obs;

  final RxDouble emiAmount = 0.0.obs;
  final RxDouble totalInterest = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;

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

  // Loan configuration
  final double minAmount = 10000;
  final double maxAmount = 1000000;
  final int minTenure = 3;
  final int maxTenure = 60;
  final double interestRate = 10.5; // Annual interest rate

  @override
  void onInit() {
    super.onInit();
    calculateLoanDetails();
  }

  @override
  void onClose() {
    amountController.dispose();
    tenureController.dispose();
    purposeController.dispose();
    super.onClose();
  }

  void selectLoanType(String type) {
    selectedLoanType.value = type;
    loanTypeError.value = '';
  }

  void updateAmount(double value) {
    selectedAmount.value = value;
    amountController.text = value.toStringAsFixed(0);
    calculateLoanDetails();
  }

  void updateTenure(int value) {
    selectedTenure.value = value;
    tenureController.text = value.toString();
    calculateLoanDetails();
  }

  void toggleTerms() {
    termsAccepted.value = !termsAccepted.value;
  }

  void calculateLoanDetails() {
    // Calculate EMI using the formula: EMI = P * r * (1+r)^n / ((1+r)^n - 1)
    // where P = Principal, r = monthly interest rate, n = number of months
    
    double principal = selectedAmount.value;
    int tenure = selectedTenure.value;
    double annualInterestRate = interestRate / 100;
    double monthlyInterestRate = annualInterestRate / 12;
    
    double emi = (principal * 
                 monthlyInterestRate * 
                 _pow(1 + monthlyInterestRate, tenure)) / 
                (_pow(1 + monthlyInterestRate, tenure) - 1);
    
    emiAmount.value = emi;
    totalAmount.value = emi * tenure;
    totalInterest.value = totalAmount.value - principal;
  }

  double _pow(double x, int n) {
    double result = 1.0;
    for (int i = 0; i < n; i++) {
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

  Future<void> submitApplication() async {
    // Validate the form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    // Validate loan type
    if (selectedLoanType.isEmpty) {
      loanTypeError.value = 'Please select a loan type';
      return;
    }
    
    // Validate terms acceptance
    if (!termsAccepted.value) {
      Get.snackbar('Error', 'Please accept the terms and conditions');
      return;
    }
    
    try {
      isLoading.value = true;
      
      final result = await _loanService.applyForLoan(
        amount: selectedAmount.value,
        tenureMonths: selectedTenure.value,
        loanType: selectedLoanType.value,
        purpose: purposeController.text.trim(),
      );
      
      if (result) {
        Get.offNamed(Routes.HOME);
        Get.snackbar(
          'Success', 
          'Your loan application has been submitted successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        Get.snackbar('Error', 'Failed to submit loan application');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
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
