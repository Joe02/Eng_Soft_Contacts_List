import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWith(email, password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<UserCredential?> registerUser(email, password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  void sendResetEmail(email) async {
    try {
      var result = await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print("Error: $e");
      return null;
    }
  }
}
