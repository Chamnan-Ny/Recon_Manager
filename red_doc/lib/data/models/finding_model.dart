import '../../utils/constants.dart';


// Represents one vulnerability finding inside a project.
// No status field here (like Open/Fixed) - that's a future feature.

class FindingModel {
  String findingId;
  String projectId;
  String title;
  Severity severity;
  String description;
  String recommendation;
  DateTime createdAt;

  FindingModel({
    required this.findingId,
    required this.projectId,
    required this.title,
    required this.severity,
    required this.description,
    required this.recommendation,
    required this.createdAt,
  });

  // Turns a Firestore document (Map) into a FindingModel object.
  static FindingModel fromMap(String id, Map<String, dynamic> map) {
    return FindingModel(
      findingId: id,
      projectId: map['projectId'],
      title: map['title'],
      severity: Severity.values.byName(map['severity']),
      description: map['description'],
      recommendation: map['recommendation'],
      createdAt: map['createdAt'].toDate(), // Firestore Timestamp -> DateTime
    );
  }

  // Turns this FindingModel back into a Map, to save it in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'severity': severity.name,
      'description': description,
      'recommendation': recommendation,
      'createdAt': createdAt,
    };
  }
}
