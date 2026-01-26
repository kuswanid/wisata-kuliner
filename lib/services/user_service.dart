import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wisata_kuliner/models/user_model.dart';

class UserService {
  Future<void> createUser(
    String id,
    String city,
    String email,
    String name,
    String role,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'city': city,
        'email': email,
        'name': name,
        'role': role,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final document = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return UserModel.fromJson(document.id, document.data()!);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
