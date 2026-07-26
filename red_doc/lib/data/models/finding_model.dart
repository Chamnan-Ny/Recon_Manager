import '../../utils/constants.dart';

class FindingModel {
  String findingId;
  String projectId;
  String title;
  Severity severity;
  String description;
  String recommendation;
  String status;
  DateTime createdAt;

  FindingModel({
    required this.findingId,
    required this.projectId,
    required this.title,
    required this.severity,
    required this.description,
    required this.recommendation,
    required this.status,
    required this.createdAt,
  });

  static FindingModel fromMap(String id, Map<String, dynamic> map) {
    // Get status with default value if missing
    String statusValue = 'Open';
    if (map['status'] != null) {
      statusValue = map['status'];
    }

    // Get severity with default if missing
    Severity severityValue = Severity.medium;
    if (map['severity'] != null) {
      severityValue = Severity.values.byName(map['severity']);
    }

    // Get createdAt with default if missing
    DateTime createdAtValue = DateTime.now();
    if (map['createdAt'] != null) {
      createdAtValue = map['createdAt'].toDate();
    }

    return FindingModel(
      findingId: id,
      projectId: map['projectId'],
      title: map['title'],
      severity: severityValue,
      description: map['description'],
      recommendation: map['recommendation'],
      status: statusValue,
      createdAt: createdAtValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'title': title,
      'severity': severity.name,
      'description': description,
      'recommendation': recommendation,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
