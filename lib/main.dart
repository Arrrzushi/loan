import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loan_app/app/data/services/auth_service.dart';
import 'package:loan_app/app/data/services/email_service.dart';
import 'package:loan_app/app/data/services/loan_service.dart';
import 'package:loan_app/app/routes/app_pages.dart';
import 'package:loan_app/app/utils/pigeon_fix.dart';
// import 'firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

// Global error handler for pigeon-related errors
Future<void> _handlePigeonError(Object error, StackTrace stack) async {
  if (error.toString().contains('PigeonUserDetails')) {
    debugPrint('Caught PigeonUserDetails error, suppressing: $error');
    // Don't report this error as it's expected and handled
  } else {
    // For other errors, use the default handler
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stack,
      library: 'Loan App',
      context: ErrorDescription('during app initialization'),
    ));
  }
}

void main() async {
  // Wrap everything in a zone to catch Pigeon errors
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Apply the fix for the PigeonUserDetails error FIRST THING
    PigeonFix.apply();

    // Print diagnostic message
    debugPrint('Starting app initialization...');

    // TEMPORARILY DISABLED Firebase initialization
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    debugPrint('App initialized successfully');

    // ✅ Initialize other services
    await initServices();

    // Final check to ensure PigeonFix is applied
    PigeonFix.apply();

    runApp(const MyApp());
  }, _handlePigeonError);
}

/// Initialize services before the app starts
Future<void> initServices() async {
  debugPrint('Initializing services...');

  // Initialize AuthService
  await Get.putAsync(() async {
    // Apply Pigeon fix before auth service initialization
    PigeonFix.apply();
    return AuthService();
  });

  // Initialize EmailService
  await Get.putAsync(() async => EmailService());

  // Initialize LoanService (depends on AuthService and EmailService)
  await Get.putAsync(() async => LoanService());

  // Make sure the Pigeon fix is applied after service initialization
  PigeonFix.apply();

  debugPrint('All services initialized');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LoanBee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7E1D),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF7E1D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7E1D),
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFFF7E1D),
              width: 2,
            ),
          ),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
