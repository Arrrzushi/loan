import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Timestamp;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore
    show Timestamp;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

// Adding Timestamp alias for easier use
typedef Timestamp = firestore.Timestamp;

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user data
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  // Mock values for UI demonstration (will update based on actual user)
  bool get isLoggedIn => firebaseUser.value != null;
  bool get isProfileComplete =>
      _currentUser.value?.phoneNumber.isNotEmpty ?? false;
  bool get isKycVerified => _currentUser.value?.kycStatus == 'verified';
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;
  Rx<UserModel?> get currentUser => _currentUser;

  String? get verificationId => _verificationId;
  String? _verificationId;

  @override
  void onInit() {
    super.onInit();
    print('AuthService initialized');

    // Listen to Firebase auth changes
    _auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
      if (user != null) {
        // Fetch user data from Firestore
        _fetchUserData(user.uid);
      } else {
        _currentUser.value = null;
      }
    });

    // Check for saved preferences (used for our direct method)
    _checkSavedCredentials();
  }

  // Check for saved login credentials in SharedPreferences
  // This is our fallback for when Firebase auth state doesn't work
  Future<void> _checkSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (isLoggedIn) {
        final userId = prefs.getString('userId');
        final userEmail = prefs.getString('userEmail');
        final userName = prefs.getString('userName');

        if (userId != null && userEmail != null && userName != null) {
          // Create a user from saved credentials
          final savedUser = UserModel(
            id: userId,
            email: userEmail,
            fullName: userName,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Only set if current user is null
          if (_currentUser.value == null) {
            _currentUser.value = savedUser;
            print('User restored from preferences: $userId');
          }
        }
      }
    } catch (e) {
      print('Error checking saved credentials: $e');
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    return _currentUser.value;
  }

  // Fetch user data from Firestore - improved to handle errors
  Future<void> _fetchUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        try {
          final data = doc.data() ?? {};

          // Add safe handling for timestamp conversion
          if (data['createdAt'] == null) {
            data['createdAt'] = DateTime.now().millisecondsSinceEpoch;
          } else if (data['createdAt'] is Timestamp) {
            data['createdAt'] =
                (data['createdAt'] as Timestamp).millisecondsSinceEpoch;
          }

          if (data['updatedAt'] == null) {
            data['updatedAt'] = DateTime.now().millisecondsSinceEpoch;
          } else if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] =
                (data['updatedAt'] as Timestamp).millisecondsSinceEpoch;
          }

          _currentUser.value = UserModel.fromMap({
            'id': doc.id,
            ...data,
          });
        } catch (formatError) {
          print('Error parsing user data: $formatError');

          // Create a minimal user with just the ID and available fields
          final data = doc.data() ?? {};
          _currentUser.value = UserModel(
            id: doc.id,
            email: data['email'] as String? ?? '',
            fullName: data['fullName'] as String? ?? 'User',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      } else {
        // User exists in Auth but not in Firestore
        _currentUser.value = null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _currentUser.value = null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          await _fetchUserData(userCredential.user!.uid);

          if (_currentUser.value == null) {
            // User exists in Auth but not in Firestore, create a basic profile
            final newUser = UserModel(
              id: userCredential.user!.uid,
              email: userCredential.user!.email ?? email,
              fullName: userCredential.user!.displayName ?? 'User',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            try {
              // Try to save to Firestore
              await _firestore
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .set(newUser.toMap());

              _currentUser.value = newUser;
            } catch (e) {
              print('Failed to save user to Firestore: $e');
              // Still set the user locally
              _currentUser.value = newUser;
            }
          }

          return _currentUser.value;
        } catch (e) {
          print('Error with user data: $e');
          // Still return a basic user object since authentication succeeded
          final basicUser = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? email,
            fullName: userCredential.user!.displayName ?? 'User',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          _currentUser.value = basicUser;
          return basicUser;
        }
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print('Sign in error: $e');
      throw e.message ?? 'Authentication failed';
    } catch (e) {
      print('Sign in error: $e');
      throw 'Authentication failed';
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      // Get the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user exists in Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // Create new user in Firestore
          final newUser = UserModel(
            id: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());
          _currentUser.value = newUser;
        } else {
          await _fetchUserData(user.uid);
        }

        return _currentUser.value;
      }

      return null;
    } catch (e) {
      print('Google Sign-in error: $e');
      return null;
    }
  }

  // Send OTP to phone number
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification on Android
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e.message ?? 'Verification failed';
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );

      return true;
    } catch (e) {
      print('Send OTP error: $e');
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_verificationId == null) {
        return false;
      }

      // Create credential
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      // Sign in with credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Link with existing user if needed
        if (firebaseUser.value != null &&
            firebaseUser.value!.uid != userCredential.user!.uid) {
          await firebaseUser.value!.updatePhoneNumber(credential);
        }

        return true;
      }

      return false;
    } catch (e) {
      print('Verify OTP error: $e');
      return false;
    }
  }

  // Register new user
  Future<UserModel?> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          // Create user in Firestore
          final newUser = UserModel(
            id: userCredential.user!.uid,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(newUser.toMap());

          // Update display name - This might trigger PigeonUserDetails error
          try {
            await userCredential.user!.updateDisplayName(fullName);
          } catch (displayNameError) {
            print('UpdateDisplayName error (non-critical): $displayNameError');
            // We can continue without updating display name
          }

          // Set the current user even if display name update fails
          _currentUser.value = newUser;
          return newUser;
        } catch (firestoreError) {
          print('Firestore error: $firestoreError');

          // Even if there's an error with Firestore, the user is created in Firebase Auth
          // So we'll create a basic user model with the available information
          final basicUser = UserModel(
            id: userCredential.user!.uid,
            email: email,
            fullName: fullName,
            phoneNumber: phoneNumber,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          _currentUser.value = basicUser;
          return basicUser;
        }
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print('Registration error (FirebaseAuthException): $e');
      throw e.message ?? 'Registration failed';
    } catch (e) {
      // Check if this is the PigeonUserDetails error
      if (e.toString().contains('PigeonUserDetails')) {
        print('Caught PigeonUserDetails error during registration: $e');

        // Try to find the user that was just created
        try {
          // Check if user exists and try to sign in
          final signInResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (signInResult.user != null) {
            // User was created but PigeonUserDetails error occurred
            final recoveredUser = UserModel(
              id: signInResult.user!.uid,
              email: email,
              fullName: fullName,
              phoneNumber: phoneNumber,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            // Try to save to Firestore in background
            _firestore
                .collection('users')
                .doc(signInResult.user!.uid)
                .set(recoveredUser.toMap())
                .catchError((e) => print('Recovery Firestore error: $e'));

            _currentUser.value = recoveredUser;
            return recoveredUser;
          }
        } catch (recoveryError) {
          print('Recovery attempt failed: $recoveryError');
          // Continue to throw the original error
        }
      }

      print('Registration error: $e');
      throw 'Registration failed: ${e.toString()}';
    }
  }

  // Upload KYC document
  Future<bool> uploadKycDocument({
    required String documentType,
    required String documentFile,
    required String selfieFile,
  }) async {
    try {
      if (firebaseUser.value == null || _currentUser.value == null) {
        return false;
      }

      // In a real app, you would upload files to Firebase Storage
      // and store references in Firestore

      // Update user KYC status in Firestore
      await _firestore.collection('users').doc(firebaseUser.value!.uid).update({
        'documentType': documentType,
        'kycDocumentUrl': 'https://example.com/documents/$documentFile',
        'kycStatus': 'pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local user model
      _currentUser.value = _currentUser.value!.copyWith(
        documentType: documentType,
        kycDocumentUrl: 'https://example.com/documents/$documentFile',
        kycStatus: 'pending',
        updatedAt: DateTime.now(),
      );

      // For demo, automatically approve KYC after delay
      await Future.delayed(const Duration(seconds: 1));

      await _firestore.collection('users').doc(firebaseUser.value!.uid).update({
        'kycStatus': 'verified',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _currentUser.value = _currentUser.value!.copyWith(
        kycStatus: 'verified',
        updatedAt: DateTime.now(),
      );

      return true;
    } catch (e) {
      print('KYC upload error: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String phoneNumber,
    required String address,
  }) async {
    try {
      if (firebaseUser.value == null || _currentUser.value == null) {
        return false;
      }

      // Update user profile in Firestore
      await _firestore.collection('users').doc(firebaseUser.value!.uid).update({
        'phoneNumber': phoneNumber,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local user model
      _currentUser.value = _currentUser.value!.copyWith(
        phoneNumber: phoneNumber,
        address: address,
        updatedAt: DateTime.now(),
      );

      return true;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password reset error: $e');
      throw e.message ?? 'Failed to send password reset email';
    } catch (e) {
      print('Password reset error: $e');
      throw 'Failed to send password reset email';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await _auth.signOut(); // Sign out from Firebase
      _currentUser.value = null;
    } catch (e) {
      print('Sign out error: $e');
      throw 'Sign out failed';
    }
  }

  // DIRECT FIX: Set current user directly without using problematic Firebase methods
  void setCurrentUserDirectly({
    required String userId,
    required String email,
    required String fullName,
    required String phoneNumber,
  }) {
    try {
      // Create a user model directly
      final user = UserModel(
        id: userId,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Set the current user directly
      _currentUser.value = user;

      // Try to get the Firebase user as well
      final currentFirebaseUser = _auth.currentUser;
      if (currentFirebaseUser != null && currentFirebaseUser.uid == userId) {
        firebaseUser.value = currentFirebaseUser;
      }

      print('User set directly in AuthService: $userId');
    } catch (e) {
      print('Error setting user directly: $e');
    }
  }
}
