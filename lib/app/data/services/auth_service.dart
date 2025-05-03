import 'package:get/get.dart';
import 'package:loan_app/app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Firebase imports commented out for mock implementation
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart' hide Timestamp;
// import 'package:cloud_firestore/cloud_firestore.dart' as firestore show Timestamp;

// Mock Firebase User
class User {
  final String uid;
  final String? email;
  final String? displayName;
  
  User({required this.uid, this.email, this.displayName});
}

// Adding Timestamp alias for easier use (not used in mock version)
// typedef Timestamp = firestore.Timestamp;

class AuthService extends GetxService {
  // Mock Firebase instances
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    // Create mock user for development
    _createMockUser();
    
    // Check for saved preferences
    _checkSavedCredentials();
  }
  
  // Create a mock user for development
  void _createMockUser() {
    final mockFirebaseUser = User(
      uid: 'user1',
      email: 'user@example.com',
      displayName: 'John Doe'
    );
    
    firebaseUser.value = mockFirebaseUser;
    
    final userModel = UserModel(
      id: 'user1',
      email: 'user@example.com',
      fullName: 'John Doe',
      phoneNumber: '1234567890',
      address: '123 Test Street',
      city: 'Test City',
      state: 'Test State',
      zipCode: '12345',
      country: 'Test Country',
      kycStatus: 'verified',
      isAdmin: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    _currentUser.value = userModel;
  }

  // Check for saved login credentials in SharedPreferences
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

  // Sign in with email and password (mock implementation)
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Mock successful authentication
      if (email.isNotEmpty && password.isNotEmpty) {
        final mockUserId = 'user1';
        
        // Create mock Firebase user
        firebaseUser.value = User(
          uid: mockUserId,
          email: email,
          displayName: 'Test User'
        );
        
        // Create user model
        final user = UserModel(
          id: mockUserId,
          email: email,
          fullName: 'John Doe',
          phoneNumber: '1234567890',
          address: '123 Test Street',
          city: 'Test City',
          state: 'Test State',
          zipCode: '12345',
          country: 'Test Country',
          isAdmin: email.contains('admin'),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _currentUser.value = user;
        
        // Save to preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('userId', user.id);
        prefs.setString('userEmail', user.email);
        prefs.setString('userName', user.fullName);
        
        return user;
      }
      
      return null;
    } catch (e) {
      print('Sign in error: $e');
      throw 'Authentication failed';
    }
  }

  // Sign in with Google (mock implementation)
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Mock Google sign-in
      final user = UserModel(
        id: 'google_user1',
        email: 'google_user@example.com',
        fullName: 'Google User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _currentUser.value = user;
      firebaseUser.value = User(
        uid: 'google_user1',
        email: 'google_user@example.com',
        displayName: 'Google User'
      );
      
      return user;
    } catch (e) {
      print('Google sign in error: $e');
      return null;
    }
  }

  // Sign up with email and password (mock implementation)
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // Mock user creation
      final user = UserModel(
        id: 'new_user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _currentUser.value = user;
      firebaseUser.value = User(
        uid: user.id,
        email: email,
        displayName: fullName
      );
      
      return user;
    } catch (e) {
      print('Sign up error: $e');
      throw 'Registration failed';
    }
  }

  // Sign out (mock implementation)
  Future<void> signOut() async {
    try {
      // Clear user data
      _currentUser.value = null;
      firebaseUser.value = null;
      
      // Clear preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      prefs.remove('userId');
      prefs.remove('userEmail');
      prefs.remove('userName');
    } catch (e) {
      print('Sign out error: $e');
      throw 'Sign out failed';
    }
  }

  // Update user profile (mock implementation)
  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      if (_currentUser.value != null) {
        // Update the current user with new values
        final updatedUser = UserModel(
          id: _currentUser.value!.id,
          email: _currentUser.value!.email,
          fullName: fullName,
          phoneNumber: phoneNumber,
          address: address ?? _currentUser.value!.address,
          city: city ?? _currentUser.value!.city,
          state: state ?? _currentUser.value!.state,
          zipCode: zipCode ?? _currentUser.value!.zipCode,
          country: country ?? _currentUser.value!.country,
          createdAt: _currentUser.value!.createdAt,
          updatedAt: DateTime.now(),
        );
        
        _currentUser.value = updatedUser;
      }
    } catch (e) {
      print('Update profile error: $e');
      throw 'Profile update failed';
    }
  }

  // Reset password (mock implementation)
  Future<void> resetPassword(String email) async {
    try {
      // Just print a confirmation message
      print('Reset password email sent to: $email');
    } catch (e) {
      print('Reset password error: $e');
      throw 'Password reset failed';
    }
  }
  
  // Get all users (for admin) - mock implementation
  Future<List<UserModel>> getAllUsers() async {
    if (!isAdmin) {
      return [];
    }
    
    // Create mock user list
    final List<UserModel> mockUsers = [
      UserModel(
        id: 'user1',
        email: 'user1@example.com',
        fullName: 'John Doe',
        phoneNumber: '1234567890',
        address: '123 Main St',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      UserModel(
        id: 'user2',
        email: 'user2@example.com',
        fullName: 'Jane Smith',
        phoneNumber: '9876543210',
        address: '456 Park Ave',
        city: 'Los Angeles',
        state: 'CA',
        zipCode: '90001',
        country: 'USA',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      UserModel(
        id: 'user3',
        email: 'user3@example.com',
        fullName: 'Bob Johnson',
        phoneNumber: '5555555555',
        address: '789 Broadway',
        city: 'Chicago',
        state: 'IL',
        zipCode: '60007',
        country: 'USA',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
    ];
    
    return mockUsers;
  }
  
  // Upload KYC document (mock implementation)
  Future<bool> uploadKycDocument({
    required String documentType,
    required String documentFile,
    required String selfieFile,
  }) async {
    try {
      if (_currentUser.value == null) {
        return false;
      }
      
      // Update local user model with mocked data
      _currentUser.value = _currentUser.value!.copyWith(
        documentType: documentType,
        kycDocumentUrl: 'https://example.com/documents/$documentFile',
        kycStatus: 'verified', // Automatically verify in mock implementation
        updatedAt: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      print('KYC upload error: $e');
      return false;
    }
  }
  
  // Set current user directly (mock implementation)
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
      
      // Create mock Firebase user
      firebaseUser.value = User(
        uid: userId,
        email: email,
        displayName: fullName
      );
      
      print('User set directly in AuthService: $userId');
    } catch (e) {
      print('Error setting user directly: $e');
    }
  }
  
  // Send OTP to phone number (mock implementation)
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      // Mock successful OTP sending
      _verificationId = 'mock-verification-id-${DateTime.now().millisecondsSinceEpoch}';
      
      print('Mock OTP sent to: $phoneNumber');
      return true;
    } catch (e) {
      print('Send OTP error: $e');
      return false;
    }
  }
  
  // Verify OTP (mock implementation)
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_verificationId == null) {
        return false;
      }
      
      // Mock successful verification (accept any OTP)
      if (otp.length >= 4) {
        return true;
      }
      
      return false;
    } catch (e) {
      print('Verify OTP error: $e');
      return false;
    }
  }
  
  // Send password reset email (mock implementation)
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Mock successful password reset email
      print('Mock password reset email sent to: $email');
    } catch (e) {
      print('Password reset error: $e');
      throw 'Failed to send password reset email';
    }
  }
}
