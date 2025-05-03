import 'package:get/get.dart';

import '../models/loan_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';
import 'email_service.dart';

class LoanService extends GetxService {
  final AuthService _authService = Get.find<AuthService>();
  final EmailService _emailService = Get.put(EmailService());

  // Mock data store
  final RxList<LoanModel> _loans = <LoanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Populate with some sample loans
    _generateSampleLoans();

    // Set up timer to check for upcoming payments daily
    // This is simplified - in a real app you'd use a background service
    // or push notifications from the server
    _setupDailyPaymentCheck();
  }

  void _setupDailyPaymentCheck() {
    // Check for loans due in the next 3 days and send reminders
    Future.delayed(const Duration(seconds: 5), () {
      checkAndSendPaymentReminders();
    });
  }

  // Get all loans (for HomeController)
  List<LoanModel> getLoans() {
    return _loans.toList();
  }

  // Get all loans - for admin only
  Future<List<LoanModel>> getAllLoans() async {
    // In a real app, this would fetch from a backend
    return _loans.toList();
  }

  // Generate some sample loans for UI testing
  void _generateSampleLoans() {
    final now = DateTime.now();

    // Sample loan 1 - Due soon
    _loans.add(LoanModel(
      id: '1',
      amount: 50000,
      emiAmount: 5000,
      tenureMonths: 12,
      interestRate: 10.5,
      status: 'approved',
      applicationDate: now.subtract(const Duration(days: 30)),
      approvalDate: now.subtract(const Duration(days: 28)),
      dueDate: now.add(const Duration(days: 3)),
      paymentDates: [
        now.subtract(const Duration(days: 27)),
      ],
      userId: 'user1',
      loanType: 'personal',
      purpose: 'Home Renovation',
      totalInstallments: 12,
      paidInstallments: 1,
      amountPaid: 5000,
      remainingAmount: 45000,
      startDate: now.subtract(const Duration(days: 28)),
      endDate: now.add(const Duration(days: 332)),
      repayments: [
        RepaymentModel(
          id: 'repay1',
          amount: 5000,
          date: now.subtract(const Duration(days: 27)),
          status: 'paid',
        ),
      ],
      userName: 'John Doe',
    ));

    // Sample loan 2 - Pending approval
    _loans.add(LoanModel(
      id: '2',
      amount: 15000,
      emiAmount: 5250,
      tenureMonths: 3,
      interestRate: 12.0,
      status: 'pending',
      applicationDate: now.subtract(const Duration(days: 2)),
      approvalDate: null,
      dueDate: now.add(const Duration(days: 28)),
      paymentDates: [],
      userId: 'user1',
      loanType: 'quick_cash',
      purpose: 'Emergency Expenses',
      totalInstallments: 3,
      paidInstallments: 0,
      amountPaid: 0,
      remainingAmount: 15000,
      startDate: now,
      repayments: [],
      userName: 'John Doe',
    ));

    // Sample loan 3 - Completed
    _loans.add(LoanModel(
      id: '3',
      amount: 10000,
      emiAmount: 3500,
      tenureMonths: 3,
      interestRate: 9.0,
      status: 'closed',
      applicationDate: now.subtract(const Duration(days: 90)),
      approvalDate: now.subtract(const Duration(days: 89)),
      dueDate: now.subtract(const Duration(days: 5)),
      paymentDates: [
        now.subtract(const Duration(days: 60)),
        now.subtract(const Duration(days: 30)),
        now.subtract(const Duration(days: 5)),
      ],
      userId: 'user1',
      loanType: 'personal',
      purpose: 'Travel',
      totalInstallments: 3,
      paidInstallments: 3,
      amountPaid: 10000,
      remainingAmount: 0,
      startDate: now.subtract(const Duration(days: 89)),
      endDate: now.subtract(const Duration(days: 5)),
      repayments: [
        RepaymentModel(
          id: 'repay3_1',
          amount: 3500,
          date: now.subtract(const Duration(days: 60)),
          status: 'paid',
        ),
        RepaymentModel(
          id: 'repay3_2',
          amount: 3500,
          date: now.subtract(const Duration(days: 30)),
          status: 'paid',
        ),
        RepaymentModel(
          id: 'repay3_3',
          amount: 3000,
          date: now.subtract(const Duration(days: 5)),
          status: 'paid',
        ),
      ],
      userName: 'John Doe',
    ));
  }

  // Get all loans for current user
  Stream<List<LoanModel>> getUserLoans() {
    // In a real app, this would filter by authenticated user ID
    return _loans.stream;
  }

  // Get all loans for current user as a list
  Future<List<LoanModel>> getUserLoansAsList() async {
    // In a real app, this would filter by authenticated user ID
    final user = Get.find<AuthService>().currentUser.value;
    if (user == null) return [];
    
    return _loans.where((loan) => loan.userId == user.id).toList();
  }

  // Apply for a new loan
  Future<bool> applyForLoan({
    required double amount,
    required int tenureMonths,
    String loanType = 'personal',
    String purpose = 'Personal Expense',
  }) async {
    try {
      final now = DateTime.now();
      final String loanId = 'loan_${now.millisecondsSinceEpoch}';

      // Calculate EMI using the formula: EMI = P * r * (1+r)^n / ((1+r)^n - 1)
      final interestRate = 10.0; // 10% per annum
      final monthlyInterestRate = interestRate / (12 * 100);
      final emi = (amount *
              monthlyInterestRate *
              _pow(1 + monthlyInterestRate, tenureMonths)) /
          (_pow(1 + monthlyInterestRate, tenureMonths) - 1);

      // Get current user
      final currentUser = _authService.currentUser.value;
      final userName = currentUser?.fullName ?? 'User';
      final userId = currentUser?.id ?? 'user1';

      // Create new loan
      final loan = LoanModel(
        id: loanId,
        amount: amount,
        emiAmount: emi,
        tenureMonths: tenureMonths,
        interestRate: interestRate,
        status: 'pending',
        applicationDate: now,
        approvalDate: null,
        dueDate: now.add(Duration(days: 30)), // First payment in 30 days
        paymentDates: [],
        userId: userId, // Use current user ID
        loanType: loanType,
        purpose: purpose,
        totalInstallments: tenureMonths,
        paidInstallments: 0,
        amountPaid: 0,
        remainingAmount: amount,
        startDate: now,
        repayments: [],
        userName: userName,
      );

      // Add to loans list
      _loans.add(loan);

      return true;
    } catch (e) {
      print('Error applying for loan: $e');
      return false;
    }
  }

  // Helper function for power calculation
  double _pow(double x, int n) {
    double result = 1.0;
    for (int i = 0; i < n; i++) {
      result *= x;
    }
    return result;
  }

  // Make a payment for a loan
  Future<bool> makePayment(String loanId, double amount) async {
    try {
      final index = _loans.indexWhere((loan) => loan.id == loanId);
      if (index == -1) return false;

      final loan = _loans[index];

      // In real app, you would process payment through a payment gateway

      // Update loan with payment info
      final updatedLoan = LoanModel(
        id: loan.id,
        amount: loan.amount,
        emiAmount: loan.emiAmount,
        tenureMonths: loan.tenureMonths,
        interestRate: loan.interestRate,
        status: loan.paidInstallments + 1 >= loan.totalInstallments
            ? 'closed'
            : 'approved',
        applicationDate: loan.applicationDate,
        approvalDate: loan.approvalDate,
        dueDate: DateTime.now()
            .add(const Duration(days: 30)), // Next payment due in 30 days
        paymentDates: [...loan.paymentDates, DateTime.now()],
        userId: loan.userId,
        loanType: loan.loanType,
        purpose: loan.purpose,
        totalInstallments: loan.totalInstallments,
        paidInstallments: loan.paidInstallments + 1,
        amountPaid: loan.amountPaid + amount,
        remainingAmount: loan.remainingAmount - amount,
        startDate: loan.startDate,
        endDate: loan.endDate,
        repayments: [...loan.repayments, RepaymentModel(
          id: 'repay${loan.id}_${loan.paidInstallments + 1}',
          amount: amount,
          date: DateTime.now(),
          status: 'paid',
        )],
      );

      // Update loan in list
      _loans[index] = updatedLoan;

      // Send payment confirmation email
      _emailService.sendPaymentConfirmation(updatedLoan,
          _authService.currentUser.value?.email ?? 'user@example.com', amount);

      return true;
    } catch (e) {
      print('Error making payment: $e');
      return false;
    }
  }

  // Approve a pending loan (admin function)
  Future<bool> approveLoan(String loanId) async {
    try {
      final index = _loans.indexWhere((loan) => loan.id == loanId);
      if (index == -1) return false;

      final loan = _loans[index];

      // Update loan status
      final updatedLoan = LoanModel(
        id: loan.id,
        amount: loan.amount,
        emiAmount: loan.emiAmount,
        tenureMonths: loan.tenureMonths,
        interestRate: loan.interestRate,
        status: 'approved',
        applicationDate: loan.applicationDate,
        approvalDate: DateTime.now(),
        dueDate: DateTime.now()
            .add(const Duration(days: 30)), // First payment due in 30 days
        paymentDates: loan.paymentDates,
        userId: loan.userId,
        loanType: loan.loanType,
        purpose: loan.purpose,
        totalInstallments: loan.totalInstallments,
        paidInstallments: loan.paidInstallments,
        amountPaid: loan.amountPaid,
        remainingAmount: loan.remainingAmount,
        startDate: loan.startDate,
        endDate: loan.endDate,
        repayments: loan.repayments,
      );

      // Update loan in list
      _loans[index] = updatedLoan;

      return true;
    } catch (e) {
      print('Error approving loan: $e');
      return false;
    }
  }

  // Check for upcoming payments and send email reminders
  Future<void> checkAndSendPaymentReminders() async {
    final now = DateTime.now();

    for (final loan in _loans) {
      // Only check approved loans
      if (loan.status != 'approved') continue;

      // Check if due date is within 3 days
      final daysUntilDue = loan.dueDate.difference(now).inDays;

      if (daysUntilDue <= 3 && daysUntilDue >= 0) {
        // Send payment reminder
        await _emailService.sendPaymentReminder(
            loan, _authService.currentUser.value?.email ?? 'user@example.com');
        print('Sent reminder for loan ${loan.id}, due in $daysUntilDue days');
      }
    }
  }

  // Get all users (admin only)
  Stream<List<UserModel>> getAllUsers() {
    if (!_authService.isAdmin) {
      return Stream.value([]);
    }
    return Stream.value([]);
  }

  // Reject a pending loan (admin function)
  Future<bool> rejectLoan(String loanId) async {
    try {
      final index = _loans.indexWhere((loan) => loan.id == loanId);
      if (index == -1) return false;

      final loan = _loans[index];

      // Update loan status
      final updatedLoan = LoanModel(
        id: loan.id,
        amount: loan.amount,
        emiAmount: loan.emiAmount,
        tenureMonths: loan.tenureMonths,
        interestRate: loan.interestRate,
        status: 'rejected',
        applicationDate: loan.applicationDate,
        approvalDate: DateTime.now(),
        dueDate: loan.dueDate,
        paymentDates: loan.paymentDates,
        userId: loan.userId,
        loanType: loan.loanType,
        purpose: loan.purpose,
        totalInstallments: loan.totalInstallments,
        paidInstallments: loan.paidInstallments,
        amountPaid: loan.amountPaid,
        remainingAmount: loan.remainingAmount,
        startDate: loan.startDate,
        endDate: loan.endDate,
        repayments: loan.repayments,
      );

      // Update loan in list
      _loans[index] = updatedLoan;

      return true;
    } catch (e) {
      print('Error rejecting loan: $e');
      return false;
    }
  }
}
