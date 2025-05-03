part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const PROFILE_SETUP = _Paths.PROFILE_SETUP;
  static const KYC_VERIFICATION = _Paths.KYC_VERIFICATION;
  static const HOME = _Paths.HOME;
  static const ONBOARDING = _Paths.ONBOARDING;
  
  // Loan routes
  static const LOAN_APPLICATION = _Paths.LOAN_APPLICATION;
  static const LOAN_DETAILS = _Paths.LOAN_DETAILS;
  static const PAYMENT = _Paths.PAYMENT;
  
  // Admin routes
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
  static const ADMIN_USERS = _Paths.ADMIN_USERS;
  static const ADMIN_LOANS = _Paths.ADMIN_LOANS;
  static const ADMIN_SETTINGS = _Paths.ADMIN_SETTINGS;
  static const ADMIN_LOAN_DETAILS = _Paths.ADMIN_LOAN_DETAILS;
  static const ADMIN_USER_DETAILS = _Paths.ADMIN_USER_DETAILS;
  static const ADMIN_USER_LOANS = _Paths.ADMIN_USER_LOANS;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const PROFILE_SETUP = '/profile-setup';
  static const KYC_VERIFICATION = '/kyc-verification';
  static const HOME = '/home';
  static const ONBOARDING = '/onboarding';
  
  // Loan paths
  static const LOAN_APPLICATION = '/loan-application';
  static const LOAN_DETAILS = '/loan-details';
  static const PAYMENT = '/payment';
  
  // Admin paths
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const ADMIN_USERS = '/admin-users';
  static const ADMIN_LOANS = '/admin-loans';
  static const ADMIN_SETTINGS = '/admin-settings';
  static const ADMIN_LOAN_DETAILS = '/admin-loan-details';
  static const ADMIN_USER_DETAILS = '/admin-user-details';
  static const ADMIN_USER_LOANS = '/admin-user-loans';
}
