import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload evidence image to Firebase Storage
  Future<String> uploadEvidence(File imageFile, String findingId) async {
    try {
      // Create a unique filename using timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'evidence/$findingId/$timestamp.jpg';

      // Create reference to Firebase Storage
      final ref = _storage.ref().child(fileName);

      // Upload the file
      await ref.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Delete evidence image from Firebase Storage
  Future<void> deleteEvidence(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  // Delete all evidence for a finding
  Future<void> deleteFindingEvidence(String findingId) async {
    try {
      final ref = _storage.ref().child('evidence/$findingId');
      final result = await ref.listAll();

      for (var item in result.items) {
        await item.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}
