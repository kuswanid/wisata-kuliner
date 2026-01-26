import 'package:cloud_firestore/cloud_firestore.dart';

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
}
