import 'package:red_doc/services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:red_doc/data/models/project_model.dart';
import 'package:red_doc/utils/constants.dart';

class ProjectRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final Uuid _uuid = const Uuid();

  Future<ProjectModel> createProject({
    required String title,
    required String target,
    required String scope,
    required String description,
    required String userId,
    required String status,
  }) async {
    final projectId = _uuid.v4();
    final project = ProjectModel(
      projectId: projectId,
      title: title,
      target: target,
      scope: scope,
      description: description,
      userId: userId,
      status: _getStatusEnum(status),
      createdAt: DateTime.now(),
    );

    await _firestoreService.addProject(project);
    return project;
  }

  Stream<List<ProjectModel>> getProjects(String userId) {
    return _firestoreService.getProjectsByUser(userId);
  }

  Future<ProjectModel?> getProject(String projectId) async {
    return await _firestoreService.getProject(projectId);
  }

  Future<void> updateProject(ProjectModel project) async {
    await _firestoreService.updateProject(project);
  }

  Future<void> deleteProject(String projectId) async {
    await _firestoreService.deleteProject(projectId);
  }

  ProjectStatus _getStatusEnum(String status) {
    if (status == 'Draft') {
      return ProjectStatus.draft;
    } else if (status == 'Pending Review') {
      return ProjectStatus.pendingReview;
    } else if (status == 'Revision Required') {
      return ProjectStatus.revisionRequired;
    } else if (status == 'Approved') {
      return ProjectStatus.approved;
    } else {
      return ProjectStatus.draft;
    }
  }
}
