import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ EMAIL LOGIN
  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ✅ GOOGLE LOGIN (NO ARGUMENTS)
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    final user = userCred.user!;

    final doc = await _firestore.collection("users").doc(user.uid).get();

    if (!doc.exists) {
      await _firestore.collection("users").doc(user.uid).set({
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "role": "student",
        "createdAt": Timestamp.now(),
      });
    }

    return userCred;
  }

  // ✅ GET ROLE
  Future<String> getRole(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc["role"];
  }
}
