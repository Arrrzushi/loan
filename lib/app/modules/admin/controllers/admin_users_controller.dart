import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AdminUsersController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final isLoading = true.obs;
  final users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Check if user is admin
    if (!_authService.isAdmin) {
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Access Denied', 'You do not have admin privileges');
      return;
    }
    
    loadUsers();
  }
  
  Future<void> loadUsers() async {
    isLoading.value = true;
    
    try {
      final usersList = await _authService.getAllUsers();
      users.assignAll(usersList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void refreshUsers() {
    loadUsers();
  }
  
  void addNewUser() {
    // In a real app, this would navigate to a user creation form
    Get.snackbar('Coming Soon', 'User creation feature will be available soon');
  }
  
  void viewUserDetails(String userId) {
    // In a real app, this would navigate to a user details page
    Get.toNamed(Routes.ADMIN_USER_DETAILS, arguments: {'userId': userId});
  }
  
  void editUser(String userId) {
    // In a real app, this would navigate to a user edit form
    Get.snackbar('Coming Soon', 'User editing feature will be available soon');
  }
  
  void viewUserLoans(String userId) {
    // Get user by ID
    final user = users.firstWhereOrNull((user) => user.id == userId);
    if (user == null) {
      Get.snackbar('Error', 'User not found');
      return;
    }
    
    // In a real app, this would navigate to a list of loans for this user
    Get.toNamed(
      Routes.ADMIN_USER_LOANS, 
      arguments: {
        'userId': userId,
        'userName': user.fullName,
      }
    );
  }
} 