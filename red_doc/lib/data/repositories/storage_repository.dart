

// import 'dart:typed_data';
// import 'package:red_doc/data/models/evidence_model.dart';
// import 'package:red_doc/services/firestore_service.dart';
// import 'package:red_doc/services/storage_service.dart';
// import 'package:uuid/uuid.dart';

// class StorageRepository {
//   final StorageService _storageService = StorageService();
//   final FirestoreService _firestoreService = FirestoreService();
//   final Uuid _uuid = const Uuid();

//   // Upload evidence
//   // Takes bytes instead of a File so this works on Flutter Web too.
//   Future<EvidenceModel> uploadEvidence({
//     required Uint8List imageBytes,
//     required String findingId,
//     String note = '',
//   }) async {
//     try {
//       // Step 1: Upload image bytes to Firebase Storage
//       final imageUrl = await _storageService.uploadEvidence(
//         imageBytes,
//         findingId,
//       );

//       // Step 2: Create evidence ID
//       final evidenceId = _uuid.v4();

//       // Step 3: Create EvidenceModel
//       final evidence = EvidenceModel(
//         evidenceId: evidenceId,
//         findingId: findingId,
//         imageUrl: imageUrl,
//         note: note,
//       );

//       // Step 4: Save metadata to Firestore
//       await _firestoreService.addEvidence(evidence);

//       return evidence;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Get evidence for a finding
//   Stream<List<EvidenceModel>> getEvidenceByFinding(String findingId) {
//     return _firestoreService.getEvidenceByFinding(findingId);
//   }

//   // Delete evidence
//   Future<void> deleteEvidence(String evidenceId, String imageUrl) async {
//     try {
//       // Step 1: Delete from Firebase Storage
//       await _storageService.deleteEvidence(imageUrl);

//       // Step 2: Delete from Firestore
//       await _firestoreService.deleteEvidence(evidenceId);
//     } catch (e) {
//       rethrow;
//     }
//   }
// }



import 'dart:convert';
import 'dart:typed_data';
import 'package:red_doc/data/models/evidence_model.dart';
import 'package:red_doc/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

// No longer talks to Firebase Storage. Evidence images are Base64-encoded
// and saved straight into the evidence Firestore document, so there's no
// separate storage bucket / download URL to manage. This works identically
// on mobile, desktop, and web since it never touches the device filesystem.
class StorageRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  // Upload evidence
  Future<EvidenceModel> uploadEvidence({
    required Uint8List imageBytes,
    required String findingId,
    String note = '',
  }) async {
    try {
      final String imageData = base64Encode(imageBytes);
      final evidenceId = _uuid.v4();

      final evidence = EvidenceModel(
        evidenceId: evidenceId,
        findingId: findingId,
        imageData: imageData,
        note: note,
        uploadedAt: DateTime.now(),
      );

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
  Future<void> deleteEvidence(String evidenceId) async {
    await _firestoreService.deleteEvidence(evidenceId);
  }
}
