import '../../utils/constants.dart';

class ProjectModel {
  String projectId;
  String title;
  String target;
  String scope;
  String description;
  String userId;
  ProjectStatus status;
  DateTime createdAt;

  ProjectModel({
    required this.projectId,
    required this.title,
    required this.target,
    required this.scope,
    required this.description,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  static ProjectModel fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      projectId: id,
      title: map['title'],
      target: map['target'],
      scope: map['scope'],
      description: map['description'],
      userId: map['userId'],
      status: ProjectStatus.values.byName(map['status']),
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'target': target,
      'scope': scope,
      'description': description,
      'userId': userId,
      'status': status.name,
      'createdAt': createdAt,
    };
  }
}
