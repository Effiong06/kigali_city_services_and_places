import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to auth state changes
  Stream<User?> get user => _auth.authStateChanges();

  // SIGN UP
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Verify email address before accessing the app
      await result.user?.sendEmailVerification();

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Return the error message to show in the UI
    }
  }

  // LOG IN
  Future<String?> logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Check if email is verified
      if (!result.user!.emailVerified) {
        return "Please verify your email first.";
      }

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // LOG OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
  