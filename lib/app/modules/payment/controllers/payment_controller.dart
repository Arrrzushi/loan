import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/loan_service.dart';

class PaymentController extends GetxController {
  final LoanService _loanService = Get.find<LoanService>();
  
  // Form keys for validation
  final cardFormKey = GlobalKey<FormState>();
  final upiFormKey = GlobalKey<FormState>();
  
  // Text field controllers
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();
  final upiIdController = TextEditingController();
  
  // Payment details
  final loanId = ''.obs;
  final amount = 0.0.obs;
  final dueDate = ''.obs;
  
  // UI state
  final isLoading = false.obs;
  final paymentSuccess = false.obs;
  final selectedPaymentMethod = ''.obs;
  final selectedBank = ''.obs;
  
  // Transaction details
  String transactionId = '';
  
  // Bank list for net banking
  final banks = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Bank of Baroda',
    'Punjab National Bank',
    'Kotak Mahindra Bank',
    'Yes Bank',
  ];
  
  @override
  void onInit() {
    super.onInit();
    _loadPaymentDetails();
  }
  
  @override
  void onClose() {
    // Dispose controllers
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    upiIdController.dispose();
    super.onClose();
  }
  
  void _loadPaymentDetails() {
    try {
      isLoading.value = true;
      
      // Get arguments from route
      final arguments = Get.arguments as Map<String, dynamic>?;
      
      if (arguments != null) {
        loanId.value = arguments['loanId'] as String? ?? '';
        amount.value = arguments['amount'] as double? ?? 0.0;
        
        // Format due date if provided
        if (arguments.containsKey('dueDate')) {
          final dueDateObj = arguments['dueDate'] as DateTime?;
          if (dueDateObj != null) {
            dueDate.value = DateFormat('MMM dd, yyyy').format(dueDateObj);
          }
        }
      }
      
      // Don't use snackbar during initialization as it can cause build errors
      // Instead, use a RxBool to track error state
      if (loanId.isEmpty) {
        print('Error: Loan ID is missing');
        // We'll handle this in the UI instead
      }
      
    } catch (e) {
      print('Error: Failed to load payment details: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    
    // Reset all form fields when changing payment method
    cardNumberController.clear();
    expiryController.clear();
    cvvController.clear();
    nameController.clear();
    upiIdController.clear();
    selectedBank.value = '';
  }
  
  Future<void> processPayment() async {
    // Validate the form based on selected payment method
    bool isValid = false;
    
    switch (selectedPaymentMethod.value) {
      case 'card':
        isValid = cardFormKey.currentState?.validate() ?? false;
        break;
      case 'upi':
        isValid = upiFormKey.currentState?.validate() ?? false;
        break;
      case 'netbanking':
        isValid = selectedBank.isNotEmpty;
        if (!isValid) {
          Get.snackbar('Error', 'Please select a bank');
        }
        break;
      default:
        Get.snackbar('Error', 'Please select a payment method');
        return;
    }
    
    if (!isValid) return;
    
    try {
      isLoading.value = true;
      
      // In a real app, this would make an API call to a payment gateway
      // For this demo, we'll just simulate a payment
      
      // Generate a random transaction ID
      final rng = Random();
      transactionId = 'TX${DateTime.now().millisecondsSinceEpoch}${rng.nextInt(1000)}';
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Record the payment
      final result = await _loanService.makePayment(loanId.value, amount.value);
      
      if (result) {
        paymentSuccess.value = true;
      } else {
        Get.snackbar('Error', 'Payment failed. Please try again.');
      }
      
    } catch (e) {
      Get.snackbar('Error', 'Payment processing failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void returnToLoans() {
    // Return to loans page with success result
    Get.back(result: true);
  }
} 