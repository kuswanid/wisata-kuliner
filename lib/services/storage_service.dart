import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  // Attempting to use the standard appspot.com bucket domain explicitly
  // to resolve the 404 error with firebasestorage.app
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'gs://wisata-kuliner-4544f.appspot.com'
  );

  Future<String> uploadImage(File file) async {
    try {
      String fileName = path.basename(file.path);
      // Construct a safe filename to avoid issues with special characters
      String safeFileName = '${DateTime.now().millisecondsSinceEpoch}_${fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '')}';
      String destination = 'menus/$safeFileName';

      print('Debug: Starting upload...');
      print('Debug: Bucket: ${_storage.bucket}');
      final user = FirebaseAuth.instance.currentUser;
      print('Debug: User: ${user?.uid}');

      if (user == null) {
        print('Debug: User is NOT logged in!');
      }

      final ref = _storage.ref(destination);
      
      // Upload execution with metadata
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final snapshot = await ref.putFile(file, metadata);
      
      // Verify upload success
      if (snapshot.state == TaskState.success) {
        return await ref.getDownloadURL();
      } else {
        throw 'Upload failed with state: ${snapshot.state}';
      }
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }
}
