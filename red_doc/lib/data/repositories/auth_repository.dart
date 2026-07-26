import 'package:red_doc/data/models/user_model.dart';
import 'package:red_doc/services/firebase_auth_service.dart';
import 'package:red_doc/services/firestore_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool isLoggedIn() {
    return _authService.getCurrentUser() != null;
  }

  // Register new user - ONLY EMAIL AND PASSWORD
  Future<UserModel> register(String email, String password, String name) async {
    try {
      // Step 1: Create user in Firebase Auth
      final userCredential = await _authService.registerWithEmailPassword(
        email,
        password,
      );

      // Step 2: Create UserModel with data
      final user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
      );

      // Step 3: Save user to Firestore
      await _firestoreService.saveUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<UserModel> login(String email, String password) async {
    try {
      // Step 1: Login with Firebase Auth
      final userCredential = await _authService.loginWithEmailPassword(
        email,
        password,
      );

      // Step 2: Get user data from Firestore
      final user = await _firestoreService.getUser(userCredential.user!.uid);

      if (user == null) {
        throw 'User data not found. Please register again.';
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  UserModel? getCurrentUser() {
    final user = _authService.getCurrentUser();
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  Stream get authStateChanges => _authService.authStateChanges;
}
