import 'dart:io';
import 'package:red_doc/data/models/evidence_model.dart';
import 'package:red_doc/services/firestore_service.dart';
import 'package:red_doc/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class StorageRepository {
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  // Upload evidence
  Future<EvidenceModel> uploadEvidence({
    required File imageFile,
    required String findingId,
    String note = '',
  }) async {
    try {
      // Step 1: Upload image to Firebase Storage
      final imageUrl = await _storageService.uploadEvidence(
        imageFile,
        findingId,
      );

      // Step 2: Create evidence ID
      final evidenceId = _uuid.v4();

      // Step 3: Create EvidenceModel
      final evidence = EvidenceModel(
        evidenceId: evidenceId,
        findingId: findingId,
        imageUrl: imageUrl,
        note: note,
      );

      // Step 4: Save metadata to Firestore
      await _firestoreService.addEvidence(evidence);

      return evidence;
    } catch (e) {
      rethrow;
    }
  }

  // Get evidence for a finding
  Stream<List<EvidenceModel>> getEvidenceByFinding(String findingId) {
    return _firestoreService.getEvidenceByFinding(findingId);
  }

  // Delete evidence
  Future<void> deleteEvidence(String evidenceId, String imageUrl) async {
    try {
      // Step 1: Delete from Firebase Storage
      await _storageService.deleteEvidence(imageUrl);

      // Step 2: Delete from Firestore
      await _firestoreService.deleteEvidence(evidenceId);
    } catch (e) {
      rethrow;
    }
  }
}
