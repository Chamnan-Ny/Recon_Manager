import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:red_doc/utils/constants.dart';

class FindingRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  Future<FindingModel> createFinding({
    required String projectId,
    required String title,
    required String severity,
    required String description,
    required String recommendation,
    required String status,
  }) async {
    final findingId = _uuid.v4();
    final finding = FindingModel(
      findingId: findingId,
      projectId: projectId,
      title: title,
      severity: _getSeverityEnum(severity),
      description: description,
      recommendation: recommendation,
      status: status,
      createdAt: DateTime.now(),
    );

    await _firestoreService.addFinding(finding);
    return finding;
  }

  Stream<List<FindingModel>> getFindingsByProject(String projectId) {
    return _firestoreService.getFindingsByProject(projectId);
  }

  Future<FindingModel?> getFinding(String findingId) async {
    return await _firestoreService.getFinding(findingId);
  }

  Future<void> updateFinding(FindingModel finding) async {
    await _firestoreService.updateFinding(finding);
  }

  Future<void> deleteFinding(String findingId) async {
    await _firestoreService.deleteFinding(findingId);
  }

  Severity _getSeverityEnum(String severity) {
    if (severity == 'Critical') {
      return Severity.critical;
    } else if (severity == 'High') {
      return Severity.high;
    } else if (severity == 'Medium') {
      return Severity.medium;
    } else if (severity == 'Low') {
      return Severity.low;
    } else if (severity == 'Informational') {
      return Severity.informational;
    } else {
      return Severity.medium;
    }
  }
}
