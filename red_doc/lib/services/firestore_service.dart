import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:red_doc/data/models/evidence_model.dart';
import 'package:red_doc/data/models/finding_model.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'name': user.name,
      'email': user.email,
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        return UserModel(
          uid: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
        );
      }
    }
    return null;
  }

  // ==================== PROJECT OPERATIONS ====================
  Future<void> addProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.projectId)
        .set(project.toMap());
  }

  Stream<List<ProjectModel>> getProjectsByUser(String userId) {
    return _firestore
        .collection('projects')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          List<ProjectModel> projects = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data != null) {
              projects.add(ProjectModel.fromMap(doc.id, data));
            }
          }
          return projects;
        });
  }

  Future<ProjectModel?> getProject(String projectId) async {
    final doc = await _firestore.collection('projects').doc(projectId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        return ProjectModel.fromMap(doc.id, data);
      }
    }
    return null;
  }

  Future<void> updateProject(ProjectModel project) async {
    await _firestore
        .collection('projects')
        .doc(project.projectId)
        .update(project.toMap());
  }

  Future<void> deleteProject(String projectId) async {
    await _firestore.collection('projects').doc(projectId).delete();
  }

  // ==================== FINDING OPERATIONS ====================
  Future<void> addFinding(FindingModel finding) async {
    await _firestore
        .collection('findings')
        .doc(finding.findingId)
        .set(finding.toMap());
  }

  Stream<List<FindingModel>> getFindingsByProject(String projectId) {
    return _firestore
        .collection('findings')
        .where('projectId', isEqualTo: projectId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          List<FindingModel> findings = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data != null) {
              findings.add(FindingModel.fromMap(doc.id, data));
            }
          }
          return findings;
        });
  }

  Future<FindingModel?> getFinding(String findingId) async {
    final doc = await _firestore.collection('findings').doc(findingId).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        return FindingModel.fromMap(doc.id, data);
      }
    }
    return null;
  }

  Future<void> updateFinding(FindingModel finding) async {
    await _firestore
        .collection('findings')
        .doc(finding.findingId)
        .update(finding.toMap());
  }

  Future<void> deleteFinding(String findingId) async {
    await _firestore.collection('findings').doc(findingId).delete();
  }

  // ==================== EVIDENCE OPERATIONS ====================
  Future<void> addEvidence(EvidenceModel evidence) async {
    await _firestore
        .collection('evidence')
        .doc(evidence.evidenceId)
        .set(evidence.toMap());
  }

  Stream<List<EvidenceModel>> getEvidenceByFinding(String findingId) {
    return _firestore
        .collection('evidence')
        .where('findingId', isEqualTo: findingId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          List<EvidenceModel> evidenceList = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data != null) {
              evidenceList.add(EvidenceModel.fromMap(doc.id, data));
            }
          }
          return evidenceList;
        });
  }

  Future<void> deleteEvidence(String evidenceId) async {
    await _firestore.collection('evidence').doc(evidenceId).delete();
  }
}
