import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/profile_setup_view.dart';
import '../modules/auth/views/kyc_verification_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/loan/bindings/loan_binding.dart';
import '../modules/loan/views/loan_application_view.dart';
import '../modules/loan/views/loan_management_view.dart';
import '../modules/loan_details/bindings/loan_details_binding.dart';
import '../modules/loan_details/views/loan_details_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';

// Admin imports
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/admin/views/admin_loans_view.dart';
import '../modules/admin/views/admin_users_view.dart';
import '../modules/admin/views/admin_loan_details_view.dart';
import '../modules/admin/views/admin_user_loans_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETUP,
      page: () => const ProfileSetupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.KYC_VERIFICATION,
      page: () => const KycVerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    
    // Loan routes
    GetPage(
      name: _Paths.LOAN_APPLICATION,
      page: () => const LoanApplicationView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_DETAILS,
      page: () => const LoanDetailsView(),
      binding: LoanDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    
    // Admin routes
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_LOANS,
      page: () => const AdminLoansView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_USERS,
      page: () => const AdminUsersView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_LOAN_DETAILS,
      page: () => const AdminLoanDetailsView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_USER_LOANS,
      page: () => const AdminUserLoansView(),
      binding: AdminBinding(),
    ),
  ];
}
