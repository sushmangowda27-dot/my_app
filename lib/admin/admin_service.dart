import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  // 🔐 CHANGE THIS EMAIL TO YOUR REAL ADMIN EMAIL
  static const String adminEmail = "admin@gmail.com";

  /// ✅ Check if current user is admin
  static bool isAdmin() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return false;
    }

    return user.email!.trim().toLowerCase() == adminEmail.trim().toLowerCase();
  }
}
