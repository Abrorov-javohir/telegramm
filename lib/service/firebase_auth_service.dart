import 'package:firebase_auth/firebase_auth.dart';
import 'package:telegramm/service/user_service.dart';

class FirebaseAuthService {
  final authService = FirebaseAuth.instance;

  Future<void> register(String email, String password) async {
    try {
      await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _addDefaultContactToCurrentUser(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, password) async {
    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _addDefaultContactToCurrentUser(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _addDefaultContactToCurrentUser(String email) async {
    final currentUser = authService.currentUser;
    if (currentUser != null) {
      final userService = UserService();
      await userService.addCurrentUserToContacts(
          currentUser.uid, "default_contact@example.com");
    }
  }
}
