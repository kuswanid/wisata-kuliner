import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<UserCredential> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Terjadi kesalahan.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> registerUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'Terjadi kesalahan.';
    } catch (e) {
      throw e.toString();
    }
  }
}
