// Represents one uploaded evidence image attached to a finding.

class EvidenceModel {
  String evidenceId;
  String findingId;
  String imageUrl;
  String note;

  EvidenceModel({
    required this.evidenceId,
    required this.findingId,
    required this.imageUrl,
    required this.note,
  });

  // Turns a Firestore document (Map) into an EvidenceModel object.
  static EvidenceModel fromMap(String id, Map<String, dynamic> map) {
    return EvidenceModel(
      evidenceId: id,
      findingId: map['findingId'],
      imageUrl: map['imageUrl'],
      note: map['note'],
    );
  }

  // Turns this EvidenceModel back into a Map, to save it in Firestore.
  Map<String, dynamic> toMap() {
    return {'findingId': findingId, 'imageUrl': imageUrl, 'note': note};
  }
}
