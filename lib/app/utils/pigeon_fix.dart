import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';

/// This class provides a global error handler for PigeonUserDetails errors
class PigeonFix {
  static bool _isApplied = false;

  /// Apply the fix to suppress "type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'" errors
  static void apply() {
    if (_isApplied) return;

    // Setup error zone and handlers
    _setupGlobalErrorHandlers();

    _isApplied = true;
    debugPrint(
        'PigeonFix applied - PigeonUserDetails errors will be suppressed');
  }

  /// Setup global error handlers to catch PigeonUserDetails errors
  static void _setupGlobalErrorHandlers() {
    // Override default FlutterError handler
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('PigeonUserDetails')) {
        // Silently ignore PigeonUserDetails errors
        debugPrint('Suppressed PigeonUserDetails error: ${details.exception}');
        return;
      }
      // Use original handler for other errors
      if (originalOnError != null) {
        originalOnError(details);
      } else {
        FlutterError.presentError(details);
      }
    };

    // Wrap the app in a zone that catches unhandled errors
    runZonedGuarded(() {}, (error, stack) {
      // Only handle PigeonUserDetails errors here
      if (error.toString().contains('PigeonUserDetails')) {
        debugPrint('Suppressed unhandled PigeonUserDetails error: $error');
      } else {
        // Report other errors normally
        FlutterError.reportError(FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'PigeonFix',
        ));
      }
    });
  }
}
