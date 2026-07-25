import '../../utils/constants.dart';

// Represents one penetration testing project.

class ProjectModel {
  String projectId;
  String title;
  String target;
  String scope;
  ProjectStatus status;
  DateTime createdAt;

  ProjectModel({
    required this.projectId,
    required this.title,
    required this.target,
    required this.scope,
    required this.status,
    required this.createdAt,
  });

  // Turns a Firestore document (Map) into a ProjectModel object.
  // id is the Firestore document id, passed in separately.
  static ProjectModel fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      projectId: id,
      title: map['title'],
      target: map['target'],
      scope: map['scope'],
      status: ProjectStatus.values.byName(map['status']),
      createdAt: map['createdAt'].toDate(), // Firestore Timestamp -> DateTime
    );
  }

  // Turns this ProjectModel back into a Map, to save it in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'target': target,
      'scope': scope,
      'status': status.name,
      'createdAt': createdAt,
    };
  }
}
