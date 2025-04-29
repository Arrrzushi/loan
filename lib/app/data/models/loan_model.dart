import 'package:intl/intl.dart';

class LoanModel {
  final String id;
  final double amount;
  final double emiAmount;
  final int tenureMonths;
  final double interestRate;
  final String status; // 'pending', 'approved', 'rejected', 'closed'
  final DateTime applicationDate;
  final DateTime? approvalDate;
  final DateTime dueDate;
  final List<DateTime> paymentDates;
  final String userId;
  final String loanType; // 'personal', 'business', etc.
  final String purpose;
  final int totalInstallments;
  final int paidInstallments;
  final double amountPaid;
  final double remainingAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final List<RepaymentModel> repayments;

  LoanModel({
    required this.id,
    required this.amount,
    required this.emiAmount,
    required this.tenureMonths,
    required this.interestRate,
    required this.status,
    required this.applicationDate,
    this.approvalDate,
    required this.dueDate,
    required this.paymentDates,
    required this.userId,
    required this.loanType,
    required this.purpose,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.amountPaid,
    required this.remainingAmount,
    required this.startDate,
    this.endDate,
    required this.repayments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'emiAmount': emiAmount,
      'tenureMonths': tenureMonths,
      'interestRate': interestRate,
      'status': status,
      'applicationDate': applicationDate.millisecondsSinceEpoch,
      'approvalDate': approvalDate?.millisecondsSinceEpoch,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'paymentDates':
          paymentDates.map((date) => date.millisecondsSinceEpoch).toList(),
      'userId': userId,
      'loanType': loanType,
      'purpose': purpose,
      'totalInstallments': totalInstallments,
      'paidInstallments': paidInstallments,
      'amountPaid': amountPaid,
      'remainingAmount': remainingAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'repayments': repayments.map((e) => e.toMap()).toList(),
    };
  }

  factory LoanModel.fromMap(Map<String, dynamic> map) {
    return LoanModel(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      emiAmount: (map['emiAmount'] ?? 0.0).toDouble(),
      tenureMonths: map['tenureMonths'] ?? 0,
      interestRate: (map['interestRate'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      applicationDate:
          DateTime.fromMillisecondsSinceEpoch(map['applicationDate'] ?? 0),
      approvalDate: map['approvalDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['approvalDate'])
          : null,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] ?? 0),
      paymentDates: (map['paymentDates'] as List<dynamic>?)
              ?.map((date) => DateTime.fromMillisecondsSinceEpoch(date))
              .toList() ??
          [],
      userId: map['userId'] ?? '',
      loanType: map['loanType'] ?? 'personal',
      purpose: map['purpose'] ?? '',
      totalInstallments: map['totalInstallments'] ?? 0,
      paidInstallments: map['paidInstallments'] ?? 0,
      amountPaid: (map['amountPaid'] ?? 0.0).toDouble(),
      remainingAmount: (map['remainingAmount'] ?? 0.0).toDouble(),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
      repayments: (map['repayments'] as List<dynamic>?)
              ?.map((e) => RepaymentModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      emiAmount: (json['emiAmount'] as num).toDouble(),
      tenureMonths: json['tenureMonths'] as int,
      interestRate: (json['interestRate'] as num).toDouble(),
      status: json['status'] as String,
      applicationDate: DateTime.parse(json['applicationDate'] as String),
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'] as String)
          : null,
      dueDate: DateTime.parse(json['dueDate'] as String),
      paymentDates: (json['paymentDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
      userId: json['userId'] as String,
      loanType: json['loanType'] as String,
      purpose: json['purpose'] as String,
      totalInstallments: json['totalInstallments'] as int,
      paidInstallments: json['paidInstallments'] as int,
      amountPaid: (json['amountPaid'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      repayments: (json['repayments'] as List<dynamic>?)
              ?.map((e) => RepaymentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Helper to get formatted due date
  String get formattedDueDate => DateFormat('MMM dd, yyyy').format(dueDate);

  // Helper to get days left until due date
  int get daysLeft => dueDate.difference(DateTime.now()).inDays;

  // Helper to get payment status
  bool get isOverdue =>
      dueDate.isBefore(DateTime.now()) && status == 'approved';

  // Helper to check if loan is active
  bool get isActive => status == 'approved';

  // Helper to get progress percentage
  double get progressPercentage => paidInstallments / totalInstallments;
}

class PaymentModel {
  final String id;
  final String loanId;
  final double amount;
  final String status; // pending, paid
  final DateTime paymentDate;
  final String transactionId;
  final String paymentMethod;

  PaymentModel({
    required this.id,
    required this.loanId,
    required this.amount,
    required this.status,
    required this.paymentDate,
    this.transactionId = '',
    this.paymentMethod = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'status': status,
      'paymentDate': paymentDate.millisecondsSinceEpoch,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] ?? '',
      loanId: map['loanId'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      paymentDate: DateTime.fromMillisecondsSinceEpoch(
          map['paymentDate'] ?? DateTime.now().millisecondsSinceEpoch),
      transactionId: map['transactionId'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
    );
  }
}

class RepaymentModel {
  final String id;
  final double amount;
  final DateTime date;
  final String status;

  RepaymentModel({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory RepaymentModel.fromMap(Map<String, dynamic> map) {
    return RepaymentModel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      status: map['status'] as String,
    );
  }

  factory RepaymentModel.fromJson(Map<String, dynamic> json) {
    return RepaymentModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }
}
