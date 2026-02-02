import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Sing up
  Future<String?> singUp(
    String email,
    String password,
    String name,
    String repeatPaswword,
  ) async {
    if (password != repeatPaswword) {
      return "Passwords do not match!";
    }
    //creating account
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      //display name
      await _auth.currentUser?.updateDisplayName(name);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Unknown Firebase error";
    } catch (e) {
      return "Error: $e";
    }
  }

  // Log in part
  Future<String?> logIn(String email, String name, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Unkown Firebase error";
    } catch (e) {
      return "Error:$e";
    }
  }

  // log out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // current user
  User? get currentUser => _auth.currentUser;
}
