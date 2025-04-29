part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const PROFILE_SETUP = _Paths.PROFILE_SETUP;
  static const KYC_VERIFICATION = _Paths.KYC_VERIFICATION;
  static const HOME = _Paths.HOME;
  static const ONBOARDING = _Paths.ONBOARDING;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const PROFILE_SETUP = '/profile-setup';
  static const KYC_VERIFICATION = '/kyc-verification';
  static const HOME = '/home';
  static const ONBOARDING = '/onboarding';
}
