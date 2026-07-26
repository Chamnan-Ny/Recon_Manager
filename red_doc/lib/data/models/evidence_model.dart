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
    String findingId = '';
    if (map['findingId'] != null) {
      findingId = map['findingId'];
    }

    String imageUrl = '';
    if (map['imagePath'] != null) {
      imageUrl = map['imagePath'];
    }

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
