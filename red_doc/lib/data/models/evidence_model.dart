// class EvidenceModel {
//   String evidenceId;
//   String findingId;
//   String imageUrl; 
//   String note;

//   EvidenceModel({
//     required this.evidenceId,
//     required this.findingId,
//     required this.imageUrl,
//     required this.note,
//   });

//   static EvidenceModel fromMap(String id, Map<String, dynamic> map) {
//     String findingId = '';
//     if (map['findingId'] != null) {
//       findingId = map['findingId'];
//     }

//     String imageUrl = '';
//     if (map['imagePath'] != null) {
//       imageUrl = map['imagePath'];
//     }

//     String note = '';
//     if (map['note'] != null) {
//       note = map['note'];
//     }

//     return EvidenceModel(
//       evidenceId: id,
//       findingId: findingId,
//       imageUrl: imageUrl,
//       note: note,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'findingId': findingId, 'imageUrl': imageUrl, 'note': note};
//   }
// }


class EvidenceModel {
  String evidenceId;
  String findingId;
  String imageData; // Base64-encoded JPEG bytes, stored directly in Firestore.
  String note;
  DateTime uploadedAt;

  EvidenceModel({
    required this.evidenceId,
    required this.findingId,
    required this.imageData,
    required this.note,
    required this.uploadedAt,
  });

  static EvidenceModel fromMap(String id, Map<String, dynamic> map) {
    String findingId = '';
    if (map['findingId'] != null) {
      findingId = map['findingId'];
    }

    String imageData = '';
    if (map['imageData'] != null) {
      imageData = map['imageData'];
    }

    String note = '';
    if (map['note'] != null) {
      note = map['note'];
    }

    DateTime uploadedAt = DateTime.now();
    if (map['uploadedAt'] != null) {
      uploadedAt = map['uploadedAt'].toDate();
    }

    return EvidenceModel(
      evidenceId: id,
      findingId: findingId,
      imageData: imageData,
      note: note,
      uploadedAt: uploadedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'findingId': findingId,
      'imageData': imageData,
      'note': note,
      'uploadedAt': uploadedAt,
    };
  }
}
