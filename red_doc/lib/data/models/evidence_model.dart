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

  static EvidenceModel fromMap(String id, Map<String, dynamic> map) {
    // Get findingId with default if missing
    String findingId = '';
    if (map['findingId'] != null) {
      findingId = map['findingId'];
    }

    // Get imageUrl with default if missing
    String imageUrl = '';
    if (map['imageUrl'] != null) {
      imageUrl = map['imageUrl'];
    }

    // Get note with default if missing
    String note = '';
    if (map['note'] != null) {
      note = map['note'];
    }

    return EvidenceModel(
      evidenceId: id,
      findingId: findingId,
      imageUrl: imageUrl,
      note: note,
    );
  }

  Map<String, dynamic> toMap() {
    return {'findingId': findingId, 'imageUrl': imageUrl, 'note': note};
  }
}
